package cn.edu.jit.exception;

/**
 * 用户异常类
 * @author jitwxs
 * @date 2018/1/2 19:07
 */
public class UserException extends Exception{

    private String message;

    @Override
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public UserException() {
        this.message = "";
    }

    public UserException(String msg) {
        this.message = msg;
    }
}
