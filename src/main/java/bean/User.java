package bean;

import java.io.Serializable;

public class User implements Serializable {

    // ログイン状態（認証済みかどうか）
    private boolean authenticated;

    // getter
    public boolean isAuthenticated() {
        return authenticated;
    }

    // setter
    public void setAuthenticated(boolean authenticated) {
        this.authenticated = authenticated;
    }
}