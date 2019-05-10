package com.ravendmaster.linearmqttdashboard.service;


import android.util.JsonReader;

import com.ravendmaster.linearmqttdashboard.TabData;
import com.ravendmaster.linearmqttdashboard.activity.MainActivity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.StringReader;
import java.util.HashMap;

public class DashboardsConfiguration {

    HashMap<Integer, String> items = new HashMap<>();

    public void put(int name, String data) {
        items.put(name, data);
    }

    public String get(int name) {
        return items.get(name);
    }

    void setFromJSONRAWString(String RawJSON) {
        items.clear();

        try {
            JSONObject jsonObj = new JSONObject(RawJSON);
            JSONArray dashboards = jsonObj.getJSONArray("dashboards");
            Integer dashboardsCount = jsonObj.getJSONArray("dashboards").length();
            for (Integer i=0; i<dashboardsCount; i++) {
                Integer id;
                String data = null;
                JSONObject dashboard = dashboards.getJSONObject(i);
                id = dashboard.getInt("id");
                if (! dashboard.isNull("dashboard"))
                  data = dashboard.getJSONArray("dashboard").toString();
                items.put(id, data);
            }
        } catch (Exception e) {
            android.util.Log.d("error", e.toString());
        }

    }

    public JSONArray getAsJSON(){
        JSONArray dashboards = new JSONArray();
        for (TabData tabData: MainActivity.presenter.getTabs().getItems()) {
            JSONObject dashboard = new JSONObject();
            try {
                dashboard.put("id", tabData.id.toString());
                JSONArray o2 = new JSONArray(items.get(tabData.id));
                dashboard.put("dashboard", o2);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            dashboards.put(dashboard);
        }
        return dashboards;
    }


}
