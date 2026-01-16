package com.vet_internal_ticket;
public class KmCreate {
    public int connectType = 0;//0:未连接 1:经典 2:BLE

    public String connectName = "";//当前连接名称

    private KmCreate(){
    }

    public static KmCreate getInstance(){
        return SingletonHolder.instance;
    }

    private static class SingletonHolder{
        private static final KmCreate instance = new KmCreate();
    }
}
