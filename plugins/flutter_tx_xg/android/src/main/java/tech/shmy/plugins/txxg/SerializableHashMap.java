package tech.shmy.plugins.txxg;

import java.io.Serializable;
import java.util.HashMap;

public class SerializableHashMap implements Serializable {
    private HashMap map;
    public HashMap getMap() {
        return map;
    }
    public void setMap(HashMap map) {
        this.map= map;
    }
}