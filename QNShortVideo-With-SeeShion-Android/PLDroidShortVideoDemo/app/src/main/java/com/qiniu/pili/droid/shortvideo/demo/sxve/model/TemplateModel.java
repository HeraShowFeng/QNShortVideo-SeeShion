package com.qiniu.pili.droid.shortvideo.demo.sxve.model;

import android.support.annotation.WorkerThread;
import android.util.SparseArray;

import com.qiniu.pili.droid.shortvideo.demo.sxve.AssetDelegate;
import com.qiniu.pili.droid.shortvideo.demo.sxve.util.FileUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class TemplateModel {
    private static final String TAG = "TemplateModel";
    private static final String CONFIG_FILE_NAME = "config.json";
    private List<AssetModel> mAssets = new ArrayList<>();
    private List<AssetModel> mReplaceableAssets = new ArrayList<>();
    public SparseArray<GroupModel> groups = new SparseArray<>();
    public final int fps;
    public int groupSize;

    @WorkerThread
    public TemplateModel(String templateFolder, AssetDelegate delegate) throws IOException, JSONException {
        File folder = new File(templateFolder);
        File configFile = new File(folder, CONFIG_FILE_NAME);
        if (!configFile.exists()) {
            throw new IllegalArgumentException("config file not found");
        }

        String configJson = FileUtils.readJsonFromFile(configFile);
        JSONObject config = new JSONObject(configJson);

        fps = config.getInt("fps");

        JSONArray assets = config.getJSONArray("assets");
        for (int i = 0; i < assets.length(); i++) {
            JSONObject asset = assets.getJSONObject(i);
            if (asset.has("ui")) {
                AssetModel assetModel = new AssetModel(folder.getPath(), asset, delegate);
                mAssets.add(assetModel);

                int group = assetModel.ui.group;
                if (groupSize < group) {
                    groupSize = group;
                }

                GroupModel groupModel = groups.get(group);
                if (groupModel == null) {
                    groupModel = new GroupModel();
                    groups.put(group, groupModel);
                }

                groupModel.add(assetModel);
            }
        }

        for (int i = 1; i <= groups.size(); i++) {
            GroupModel groupModel = groups.get(i);
            SparseArray<AssetModel> groupAssets = groupModel.getAssets();
            for (int j = 0; j < groupAssets.size(); j++) {
                if (groupAssets.get(j).type == AssetModel.TYPE_MEDIA) {
                    mReplaceableAssets.add(groupAssets.get(j));
                }
            }
        }
    }

    @WorkerThread
    public String[] getReplaceableFilePaths(String folder) {
        String[] paths = new String[mAssets.size()];
        for (int i = 0; i < mAssets.size(); i++) {
            paths[i] = mAssets.get(i).ui.getSnapPath(folder);
        }
        return paths;
    }

    public int getAssetsSize() {
        return mReplaceableAssets.size();
    }

    public void setReplaceFiles(List<String> paths) {
        for (int i = 0; i < paths.size(); i++) {
            AssetModel assetModel = mReplaceableAssets.get(i);
            ((MediaUiModel) assetModel.ui).setImageAsset(paths.get(i));
        }
    }
}
