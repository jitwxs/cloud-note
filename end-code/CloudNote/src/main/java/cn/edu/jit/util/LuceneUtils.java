package cn.edu.jit.util;

import java.io.*;
import java.nio.file.FileSystems;
import java.util.*;

import cn.edu.jit.global.GlobalConstant;
import cn.edu.jit.global.GlobalFunction;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.DirectoryFileFilter;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryparser.classic.MultiFieldQueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;
import org.apache.lucene.search.highlight.SimpleSpanFragmenter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.wltea.analyzer.lucene.IKAnalyzer;

/**
 * Lucene工具类
 *
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
        if (!fileIndex.exists()) {
            GlobalFunction.createDir(indexPath);
        }
    }

    /**
     * 创建指定目录的索引
     *
     * @param dirPath   要创建索引的路径
     * @param indexPath 索引路径
     */
    public static void createIndex(String dirPath, String indexPath) throws IOException {
        String content;
        // 定义词法分析器
        Analyzer analyzer = new IKAnalyzer(true);
        // 确定索引存储位置，使用本地存储
        Directory directory = FSDirectory.open(FileSystems.getDefault().getPath(indexPath));

        // 创建IndexWriter，进行索引文件的写入
        IndexWriterConfig indexWriterConfig = new IndexWriterConfig(analyzer);
        IndexWriter indexWriter = new IndexWriter(directory, indexWriterConfig);

        // 清除以前的index
        indexWriter.deleteAll();

        // 递归遍历笔记文件
        Collection<File> listFiles = FileUtils.listFiles(new File(dirPath),
                FileFilterUtils.suffixFileFilter(GlobalConstant.NOTE_SUFFIX), DirectoryFileFilter.INSTANCE);
        for (File file : listFiles) {
            // 获取文件内容
            content = note2String(file);
            // 申请了一个document对象，这个类似于数据库中的表中的一行
            Document document = new Document();
            // 存储索引数据
            String fileName = file.getName();
            fileName = fileName.substring(0,fileName.indexOf(GlobalConstant.NOTE_SUFFIX));
            document.add(new Field("fileName", fileName, TextField.TYPE_STORED));
            document.add(new Field("content", content, TextField.TYPE_STORED));
            document.add(new Field("parentName", file.getParent(), TextField.TYPE_STORED));
            // doc对象加入IndexWriter，并提交
            indexWriter.addDocument(document);
        }

        indexWriter.commit();
        indexWriter.close();
    }

    /**
     * 查找索引，返回符合条件的文件id集合
     *
     * @param keyWord   关键字
     * @param indexPath 索引路径
     */
    public static List<Map<String,String>> searchIndex(String keyWord, String indexPath) throws Exception {
        List<Map<String,String>> list = new ArrayList<>();

        Directory directory = FSDirectory.open(FileSystems.getDefault().getPath(indexPath));
        // 打开存储位置
        DirectoryReader reader = DirectoryReader.open(directory);
        // 创建搜索器
        IndexSearcher indexSearcher = new IndexSearcher(reader);

        // 使用IK分词
        Analyzer analyzer = new IKAnalyzer(true);

        // 要搜索的字段，一般搜索时都不会只搜索一个字段
        String[] fields = {"fileName", "content"};
        // 字段之间的与或非关系，MUST表示and，MUST_NOT表示not，SHOULD表示or，有几个fields就必须有几个clauses
        BooleanClause.Occur[] clauses = {BooleanClause.Occur.SHOULD, BooleanClause.Occur.SHOULD};
        // MultiFieldQueryParser表示多个域解析， 同时可以解析含空格的字符串，如果我们搜索"上海 中国"
        Query multiFieldQuery = MultiFieldQueryParser.parse(keyWord, fields, clauses, analyzer);

        // 搜索前100条结果
        TopDocs topDocs = indexSearcher.search(multiFieldQuery, 100);
        // 根据TopDocs获取ScoreDoc对象
        ScoreDoc[] scoreDocs = topDocs.scoreDocs;

        QueryScorer scorer = new QueryScorer(multiFieldQuery, "content");
        // 自定义高亮代码
        SimpleHTMLFormatter htmlFormatter = new SimpleHTMLFormatter("<span style=\"color:red\">", "</span>");
        Highlighter highlighter = new Highlighter(htmlFormatter, scorer);
        highlighter.setTextFragmenter(new SimpleSpanFragmenter(scorer));

        for (ScoreDoc scoreDoc : scoreDocs) {
            // 根据searcher和ScoreDoc对象获取具体的Document对象
            Document document = indexSearcher.doc(scoreDoc.doc);

            // 获取搜索结果父目录名称，即笔记id，非空
            String parentName = document.get("parentName");
            String noteId = parentName.substring(parentName.lastIndexOf("article") + 8);

            // 如果笔记名包含关键字，则高亮显示，否则不高亮显示，非空
            String noteName = highlighter.getBestFragment(analyzer, "fileName", document.get("fileName"));
            if(StringUtils.isEmpty(noteName)) {
                noteName = document.get("fileName");
            }

            // 高亮显示内容，有可能为空
            String content = highlighter.getBestFragment(analyzer, "content", document.get("content"));

            Map<String,String> map = new HashMap<>(16);
            map.put("noteId", noteId);
            map.put("noteName", noteName);
            map.put("content", content);
            list.add(map);
        }

        // 关闭资源
        reader.close();
        directory.close();

        return list;
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
                sb.append(buf, 0, len);
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return GlobalFunction.getHtmlText(sb.toString());
    }
}
