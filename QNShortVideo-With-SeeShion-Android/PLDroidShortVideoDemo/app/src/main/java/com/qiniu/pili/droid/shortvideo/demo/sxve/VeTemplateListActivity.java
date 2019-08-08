package com.qiniu.pili.droid.shortvideo.demo.sxve;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.MenuItem;
import android.view.View;

import com.qiniu.pili.droid.shortvideo.demo.R;
import com.qiniu.pili.droid.shortvideo.demo.activity.PlaybackActivity;

import com.qiniu.pili.droid.shortvideo.demo.sxve.adapter.VeTemplateListAdapter;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.Template;
import com.qiniu.pili.droid.shortvideo.demo.sxve.util.AssetsUtils;
import com.qiniu.pili.droid.shortvideo.demo.sxve.view.SXProgressDialog;



import com.shixing.sxvideoengine.SXRenderListener;
import com.shixing.sxvideoengine.SXTemplate;
import com.shixing.sxvideoengine.SXTemplateRender;
import com.shixing.sxvideoengine.SXTextCanvas;
import com.zhihu.matisse.Matisse;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.EnumSet;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import static com.zhihu.matisse.MimeType.AVI;
import static com.zhihu.matisse.MimeType.JPEG;
import static com.zhihu.matisse.MimeType.MKV;
import static com.zhihu.matisse.MimeType.MP4;
import static com.zhihu.matisse.MimeType.MPEG;
import static com.zhihu.matisse.MimeType.PNG;
import static com.zhihu.matisse.MimeType.QUICKTIME;
import static com.zhihu.matisse.MimeType.THREEGPP;
import static com.zhihu.matisse.MimeType.THREEGPP2;
import static com.zhihu.matisse.MimeType.TS;
import static com.zhihu.matisse.MimeType.WEBM;

public class VeTemplateListActivity extends AppCompatActivity {

    private static final int              REQUEST_DYNAMIC = 21;
    public static final  int              REQUEST_STORAGE_PERMISSION = 31;
    private              String           mFolderName;
    private Template mTemplate;
    private              SXProgressDialog mDialog;
    private              Handler          mHandler;
    private              File             mFolder;

    public static void start(Context context, String folder, String title) {
        Intent starter = new Intent(context, VeTemplateListActivity.class);
        starter.putExtra("folder", folder);
        starter.putExtra("title", title);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ve_sample);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        String title = getIntent().getStringExtra("title");
        setTitle(title);

        mHandler = new Handler();

        mFolderName = getIntent().getStringExtra("folder");
        mFolder = getExternalFilesDir(mFolderName);

        readAsset();
    }

    private void readAsset() {
        try {
            InputStream is = getAssets().open(mFolderName + "/info.json");
            byte[] bytes = new byte[is.available()];
            is.read(bytes);
            is.close();
            String json = new String(bytes);
            initList(json);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void initList(String infoJson) {
        RecyclerView list = findViewById(R.id.list);
        list.setLayoutManager(new LinearLayoutManager(this));
        VeTemplateListAdapter adapter = new VeTemplateListAdapter();
        list.setAdapter(adapter);
        adapter.setOnTemplateClickListener(new VeTemplateListAdapter.OnTemplateClickListener() {
            @Override
            public void onTemplateClick(final Template template) {
                final File folder = new File(mFolder, template.folder);
                if (!folder.exists()) {
                    findViewById(R.id.progress_bar).setVisibility(View.VISIBLE);
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            AssetsUtils.copyDirFromAssets(VeTemplateListActivity.this, mFolderName + File.separator + template.folder, folder.getPath());
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    findViewById(R.id.progress_bar).setVisibility(View.GONE);
                                    onClick(template);
                                }
                            });
                        }
                    }).start();
                } else {
                    onClick(template);
                }
            }
        });

        ArrayList<Template> templates = parseJson(infoJson);
        adapter.setData(templates);
    }

    private void onClick(Template template) {
        if (mFolderName.equals(VeFunctionActivity.TEMPLATE_FOLDER)) {
            TemplateEditActivity.start(VeTemplateListActivity.this,
                    new File(mFolder, template.folder).getPath());
        } else {
            mTemplate = template;
            if (ContextCompat.checkSelfPermission(VeTemplateListActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(VeTemplateListActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_STORAGE_PERMISSION);
            } else {
                pickAssets();
            }
        }
    }

    private void pickAssets() {
        Matisse.from(this)
                .choose(EnumSet.of(JPEG, PNG, MPEG, MP4, QUICKTIME, THREEGPP, THREEGPP2, MKV, WEBM, TS, AVI), false)
                .showSingleMediaType(true)
                .maxSelectable(100)
                .setMinSelect(3)
                .picDetail(false)
                .countable(true)
                .theme(R.style.Matisse_Dracula)
                .forResult(REQUEST_DYNAMIC);
    }

    private ArrayList<Template> parseJson(String infoJson) {
        ArrayList<Template> templates = new ArrayList<>();
        try {

            JSONArray info = new JSONArray(infoJson);
            for (int i = 0; i < info.length(); i++) {
                JSONObject object = info.getJSONObject(i);
                Template template = new Template(
                        object.getString("name"),
                        object.getString("folder"),
                        object.getString("desciption")
                );
                templates.add(template);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return templates;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_DYNAMIC && resultCode == RESULT_OK) {
            List<String> pathList = Matisse.obtainPathResult(data);
            String[] paths = new String[pathList.size()];
            pathList.toArray(paths);

            startRender(paths);
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_STORAGE_PERMISSION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pickAssets();
            }
        }
    }

    private void startRender(String[] paths) {
        if (mDialog == null) {
            mDialog = new SXProgressDialog();
        }
        mHandler.post(new Runnable() {
            @Override
            public void run() {
                mDialog.show(getSupportFragmentManager(), mDialog.getClass().getSimpleName());
            }
        });

        String folder = new File(mFolder, mTemplate.folder).getPath();
        SXTemplate template = new SXTemplate(folder, SXTemplate.TemplateUsage.kForRender);
        template.setReplaceableFilePaths(paths);

        final String outputFilePath = getOutputFilePath();
        String title = template.getAssetJsonForUIKey("title");
        if (!TextUtils.isEmpty(title)) {
            SXTextCanvas sxTextCanvas = new SXTextCanvas(title);
            SimpleDateFormat format = new SimpleDateFormat("制作日期：\nyyyy年M月d日", Locale.US);
            sxTextCanvas.setContent(format.format(new Date()));
            sxTextCanvas.adjustSize();
            String path = sxTextCanvas.saveToPath(getExternalCacheDir() + File.separator + UUID.randomUUID() + ".png");
            template.setFileForAsset("title", path);
        }
        template.commit();

        SXTemplateRender sxTemplateRender = new SXTemplateRender(template, "", outputFilePath);
        sxTemplateRender.setBitrateFactor(0.5f);
        sxTemplateRender.setRenderListener(new SXRenderListener() {
            @Override
            public void onStart() {

            }

            @Override
            public void onUpdate(int progress) {
                mDialog.setProgress(progress);
            }

            @Override
            public void onFinish(boolean success, String msg) {
                mDialog.dismiss();
                PlaybackActivity.start(VeTemplateListActivity.this, outputFilePath);
            }

            @Override
            public void onCancel() {

            }
        });
        sxTemplateRender.start();
    }

    public String getOutputFilePath() {
        return getExternalFilesDir("video") + File.separator + System.currentTimeMillis() + ".mp4";
    }
}
