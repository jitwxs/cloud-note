package cn.edu.jit.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import com.aspose.cells.License;
import com.aspose.cells.SaveFormat;
import com.aspose.cells.Workbook;

/**
 * @author jitwxs
 * @date 2018/1/6 22:42
 */
public class ExcelToPdf {

    /**
     * 主方法
     * @param inputFile 输入文件全路径
     * @param outputFile 输出文件全路径
     * @return 耗时(s) ，失败返回-1
     */
    public static int run(String inputFile, String outputFile) {
        // 验证License
        if (!getLicense()) {
            return -1;
        }
        try {
            long old = System.currentTimeMillis();
            Workbook wb = new Workbook(inputFile);
            File pdfFile = new File(outputFile);
            FileOutputStream fileOS = new FileOutputStream(pdfFile);
            wb.save(fileOS, SaveFormat.PDF);
            long now = System.currentTimeMillis();
            return (int)((now - old) / 1000.0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  -1;
    }

    private static boolean getLicense() {
        boolean result = false;
        try {
            InputStream is = ExcelToPdf.class.getClassLoader().getResourceAsStream("license.xml");
            License aposeLic = new License();
            aposeLic.setLicense(is);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
