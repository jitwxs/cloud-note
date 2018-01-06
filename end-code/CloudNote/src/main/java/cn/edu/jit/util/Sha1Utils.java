package cn.edu.jit.util;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.Validate;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;

/**
 * SHA-1加密类（包含salt）
 * 依赖commons-lang3.jar和commons-codec.jar
 * @author jitwxs
 * @date 2018/1/2 20:50
 */
public class Sha1Utils {
    public static final int HASH_INTERATIONS = 1024;
    public static final int SALT_SIZE = 8;
    private static final String SHA1 = "SHA-1";

    private static SecureRandom random = new SecureRandom();

    /**
     * 生成安全的密码，生成随机的16位salt并经过1024次 sha-1 hash
     *
     * @param plainPassword 明文
     * @return 密文(56位)
     * @author jitwxs
     */
    public static String entryptPassword(String plainPassword) {
        byte[] salt = generateSalt(SALT_SIZE);
        byte[] hashPassword = sha1(plainPassword.getBytes(), salt, HASH_INTERATIONS);
        return encodeHex(salt) + encodeHex(hashPassword);
    }

    /**
     * 验证密码
     * @param plainPassword 明文
     * @param password      密文
     * @return 验证结果
     * @author jitwxs
     */
    public static boolean validatePassword(String plainPassword, String password) {
        byte[] salt = decodeHex(password.substring(0, 16));
        byte[] hashPassword = sha1(plainPassword.getBytes(), salt, HASH_INTERATIONS);
        return password.equals(encodeHex(salt) + encodeHex(hashPassword));
    }

    /**
     * 生成随机的Byte[]作为salt
     * @param numBytes byte数组的大小
     * @return
     * @author jitwxs
     */
    private static byte[] generateSalt(int numBytes) {
        Validate.isTrue(numBytes > 0, "numBytes argument must be a positive integer (1 or larger)", numBytes);
        byte[] bytes = new byte[numBytes];
        random.nextBytes(bytes);
        return bytes;
    }

    /**
     * Hex编码
     * @param input
     * @return
     * @author jitwxs
     */
    private static String encodeHex(byte[] input) {
        return new String(Hex.encodeHex(input));
    }

    /**
     * Hex解码
     * @param input
     * @return
     * @author jitwxs
     */
    private static byte[] decodeHex(String input) {
        try {
            return Hex.decodeHex(input.toCharArray());
        } catch (DecoderException e) {
            return null;
        }
    }

    /**
     * 对输入字符串进行sha1散列
     * @param input
     * @param salt
     * @param iterations
     * @return
     * @author jitwxs
     */
    private static byte[] sha1(byte[] input, byte[] salt, int iterations) {
        return digest(input, SHA1, salt, iterations);
    }

    /**
     * 对字符串进行散列
     * @param input
     * @param algorithm
     * @param salt
     * @param iterations
     * @return
     * @author jitwxs
     */
    private static byte[] digest(byte[] input, String algorithm, byte[] salt, int iterations) {
        try {
            MessageDigest digest = MessageDigest.getInstance(algorithm);

            if (salt != null) {
                digest.update(salt);
            }

            byte[] result = digest.digest(input);

            for (int i = 1; i < iterations; i++) {
                digest.reset();
                result = digest.digest(result);
            }
            return result;
        } catch (GeneralSecurityException e) {
            return null;
        }
    }
}