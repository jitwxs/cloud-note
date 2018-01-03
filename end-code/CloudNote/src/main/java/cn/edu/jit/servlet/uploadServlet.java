//package cn.edu.jit.servlet;
//
//import cn.edu.jit.global.GlobalFunction;
//import org.apache.commons.fileupload.FileItem;
//import org.apache.commons.fileupload.disk.DiskFileItemFactory;
//import org.apache.commons.fileupload.servlet.ServletFileUpload;
//import org.apache.commons.io.IOUtils;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.*;
//import java.util.List;
//
///**
// * 文件上传（只支持POST上传）
// * 拦截URL: /upload , post
// * @author jitwxs
// * @date 2018/1/3 21:40
// */
//public class uploadServlet extends HttpServlet{
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
//        String temp_path = this.getServletContext().getRealPath("temp"); // 获取temp文件夹路径
//        String upload_path = this.getServletContext().getRealPath("upload"); // 获取upload文件夹路径
//        try {
//            /* 1.创建磁盘文件项工厂
//                sizeThreshold：每次缓存大小，单位为字节  File：临时文件路径*/
//            DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024,new File(temp_path));
//
//            // 2.创建文件上传核心类
//            ServletFileUpload upload = new ServletFileUpload(factory);
//            // 设置上传文件的编码
//            upload.setHeaderEncoding("UTF-8");
//
//            // 3.判断是否为上传文件的表单
//            if (upload.isMultipartContent(request)) {
//                // 4.解析request获得文件项集合
//                List<FileItem> fileItems = upload.parseRequest(request);
//                if(fileItems.size() != 0) {
//                    for(FileItem item : fileItems) {
//                        // 5,判断不是一个普通的表单项
//                        if(!item.isFormField()) {
//                            // 获得文件上传名
//                            String fileName = item.getName();
//                            // 流拷贝
//                            InputStream in = item.getInputStream();
//                            OutputStream out = new FileOutputStream(upload_path + "/" + GlobalFunction.getSelfTel() + "/" + fileName);
//                            IOUtils.copy(in, out);
//                            in.close();
//                            out.close();
//                            // 删除临时文件
//                            item.delete();
//                        }
//                    }
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        super.doGet(req, resp);
//    }
//}
