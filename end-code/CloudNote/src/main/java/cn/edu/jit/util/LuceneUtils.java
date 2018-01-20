package cn.edu.jit.util;

import java.io.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.DirectoryFileFilter;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field.Store;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

/**
 * Lucene工具类
 * @author jitwxs
 * @date 2018/1/18 19:52
 */
public class LuceneUtils {
    /**
     * 准备索引，最先调用
     */
    public static void prepareIndex(String indexPath) {
        File fileIndex = new File(indexPath);
        FileUtils.deleteQuietly(fileIndex);
        if(!fileIndex.exists()) {
            GlobalFunction.createDir(indexPath);
        }
    }

    /**
     * 创建指定目录的索引
     * @param dirPath 要创建索引的路径
     * @param indexPath 索引路径
     */
    public static boolean createIndex(String dirPath, String indexPath) {
        String content;

        // 递归遍历笔记文件
        Collection<File> listFiles = FileUtils.listFiles(new File(dirPath),
                FileFilterUtils.suffixFileFilter(GlobalConstant.NOTE_SUFFIX), DirectoryFileFilter.INSTANCE);
        for (File file : listFiles) {
            // 获取文件内容
            content = note2String(file);
            try {
                // 定义词法分析器，Version.LUCENE_CURRENT：当前Lucene版本
                Analyzer analyzer = new StandardAnalyzer(Version.LUCENE_CURRENT);
                // 确定索引存储位置，使用本地村春
                Directory directory = FSDirectory.open(new File(indexPath));

                // 创建IndexWriter，进行索引文件的写入
                IndexWriterConfig config = new IndexWriterConfig(Version.LUCENE_CURRENT, analyzer);
                IndexWriter indexWriter = new IndexWriter(directory, config);

                // 申请了一个document对象，这个类似于数据库中的表中的一行
                Document document = new Document();
                // 存储索引数据
                document.add(new StringField("filename", file.getName(), Store.YES));
                document.add(new TextField("content", content, Store.YES));
                document.add(new StringField("parentName", file.getParent(), Store.YES));
                // doc对象加入IndexWriter，并提交
                indexWriter.addDocument(document);
                indexWriter.commit();

                indexWriter.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return true;
    }

    /**
     * 查找索引，返回符合条件的文件id集合
     * @param text 关键字
     * @param indexPath 索引路径
     */
    public static List<String> searchIndex(String text, String indexPath) {
        List<String> ids = new ArrayList<>();
        try {
            Directory directory = FSDirectory.open(new File(indexPath));
            Analyzer analyzer = new StandardAnalyzer(Version.LUCENE_CURRENT);
            // 打开存储位置
            DirectoryReader reader = DirectoryReader.open(directory);
            // 创建搜索器
            IndexSearcher searcher = new IndexSearcher(reader);
            // 类似SQL，进行关键字查询
            QueryParser parser = new QueryParser(Version.LUCENE_CURRENT, "content", analyzer);
            Query query = parser.parse(text);

            ScoreDoc[] hits = searcher.search(query, null, 1000).scoreDocs;
            for (int i = 0; i < hits.length; i++) {
                Document hitDoc = searcher.doc(hits[i].doc);

                // 获取搜索结果父目录名称，即笔记id
                String parentName = hitDoc.get("parentName");
                parentName = parentName.substring(parentName.lastIndexOf("article") + 8);
                ids.add(parentName);
            }

            // 关闭资源
            reader.close();
            directory.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    /**
     * 读取笔记的内容·
     */
    static String note2String(File file) {
        StringBuilder sb = new StringBuilder();
        try {
            // 获取文件内容
            InputStreamReader in = new InputStreamReader(new FileInputStream(file), "UTF-8");
            int len;
            char[] buf = new char[1024];
            while ((len = in.read(buf, 0, buf.length)) > 0) {
                sb.append(buf,0,len);
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sb.toString();
    }
}
