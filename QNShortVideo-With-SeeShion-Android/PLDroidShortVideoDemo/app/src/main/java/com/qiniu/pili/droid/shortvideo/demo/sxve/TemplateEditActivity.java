package com.qiniu.pili.droid.shortvideo.demo.sxve;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.MimeTypeMap;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.Toast;

import com.qiniu.pili.droid.shortvideo.demo.R;
import com.qiniu.pili.droid.shortvideo.demo.activity.PlaybackActivity;
import com.qiniu.pili.droid.shortvideo.demo.sxve.adapter.GroupThumbAdapter;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.GroupModel;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.MediaUiModel;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.TemplateModel;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.TextUiModel;
import com.qiniu.pili.droid.shortvideo.demo.sxve.util.GroupThumbDecoration;
import com.qiniu.pili.droid.shortvideo.demo.sxve.view.SXProgressDialog;
import com.qiniu.pili.droid.shortvideo.demo.sxve.view.TemplateView;
import com.qiniu.pili.droid.shortvideo.demo.sxve.view.TestAssetEditLayout;
import com.shixing.sxvideoengine.SXRenderListener;
import com.shixing.sxvideoengine.SXTemplate;
import com.shixing.sxvideoengine.SXTemplateRender;
import com.zhihu.matisse.Matisse;
import com.zhihu.matisse.MimeType;

import org.json.JSONException;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

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


public class TemplateEditActivity extends AppCompatActivity implements AssetDelegate {
    private static final String TAG = "TemplateEditActivity";
    private static final String KEY_FOLDER = "KEY_FOLDER";
    private static final int REQUEST_SINGLE_MEDIA = 11;
    private static final int REQUEST_MULTI_IMAGE = 12;
    private static final int REQUEST_PERMISSION_MULTI = 21;
    private static final int REQUEST_PERMISSION_SINGLE = 22;
    private static final int REQUEST_CLIP_VIDEO = 31;

    private String mTemplateFolder;
    private float mBitrateFactor=0.5f;

    private FrameLayout mContainer;
    private ArrayList<TemplateView> mTemplateViews;
    private GroupThumbAdapter mGroupThumbAdapter;
    private MediaUiModel mModel;
    private TestAssetEditLayout mTextEditLayout;
    private TemplateModel mTemplateModel;
    private SXProgressDialog mDialog;
    private ThreadPoolExecutor mThreadPoolExecutor;
    private EditText mBitrateFactorText;

    public static void start(Context context, String folder) {
        Intent starter = new Intent(context, TemplateEditActivity.class);
        starter.putExtra(KEY_FOLDER, folder);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setTheme(R.style.SXVE);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_template_edit);
        mContainer = findViewById(R.id.edit_view_container);

        mTemplateFolder = getIntent().getStringExtra(KEY_FOLDER);
        new LoadTemplateTask().execute(mTemplateFolder);

        mTemplateViews = new ArrayList<>();

        initThumb();
        mTextEditLayout = findViewById(R.id.text_edit_layout);
        mBitrateFactorText=findViewById(R.id.et_bitrateFactor);

        mDialog = new SXProgressDialog();
        mThreadPoolExecutor = new ThreadPoolExecutor(1, 1, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>(), new ThreadFactory() {
            @Override
            public Thread newThread(Runnable r) {
                Thread thread = new Thread(r);
                thread.setName("renderThread");
                return thread;
            }
        });
    }

    private void initThumb() {
        RecyclerView thumbList = findViewById(R.id.list_thumb);
        thumbList.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        thumbList.addItemDecoration(new GroupThumbDecoration());
        mGroupThumbAdapter = new GroupThumbAdapter();
        thumbList.setAdapter(mGroupThumbAdapter);
        mGroupThumbAdapter.setOnItemSelectedListener(new GroupThumbAdapter.OnItemSelectedListener() {
            @Override
            public void onItemSelected(int index) {
                selectGroup(index);
            }
        });
    }

    public void selectGroup(int index) {
        for (int i = 0; i < mTemplateViews.size(); i++) {
            mTemplateViews.get(i).setVisibility(i == index ? View.VISIBLE : View.GONE);
        }
    }

    public void done(View view) {
        render();
    }

    private void render() {
        if (mBitrateFactorText.getText().toString().length()>0){
            mBitrateFactor=Float.parseFloat(mBitrateFactorText.getText().toString());
        }
        mDialog.show(getSupportFragmentManager(), mDialog.getClass().getSimpleName());
        mThreadPoolExecutor.execute(new Runnable() {
            @Override
            public void run() {
                String[] paths = mTemplateModel.getReplaceableFilePaths(getExternalCacheDir().getPath());

                SXTemplate template = new SXTemplate(mTemplateFolder, SXTemplate.TemplateUsage.kForRender);
                template.setReplaceableFilePaths(paths);
                template.commit();
                final String outputPath = getOutputPath();
                SXTemplateRender sxTemplateRender = new SXTemplateRender(template, null, outputPath);
                sxTemplateRender.setBitrateFactor(mBitrateFactor);
                sxTemplateRender.start();
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
                        if (!success) {
                            Log.d(TAG, "onFinish: " + msg);
                            Toast.makeText(TemplateEditActivity.this, msg, Toast.LENGTH_SHORT).show();
                        } else {
                            PlaybackActivity.start(TemplateEditActivity.this, outputPath);
                        }
                    }

                    @Override
                    public void onCancel() {

                    }
                });
            }
        });
    }

    private String getOutputPath() {
        return getExternalFilesDir("video") + File.separator + System.currentTimeMillis() + "test.mp4";
    }

    @Override
    public void pickMedia(MediaUiModel model) {
        mModel = model;
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_PERMISSION_SINGLE);
        } else {
            pickSingleMedia();
        }
    }

    private void pickSingleMedia() {
        Matisse.from(this).choose(EnumSet.of(JPEG, PNG, MPEG, MP4, QUICKTIME, THREEGPP, THREEGPP2, MKV, WEBM, TS, AVI)).maxSelectable(1).showSingleMediaType(true).picDetail(false).countable(true).theme(R.style.Matisse_Dracula).forResult(REQUEST_SINGLE_MEDIA);
    }

    @Override
    public void editText(TextUiModel model) {
        mTextEditLayout.setVisibility(View.VISIBLE);
        mTextEditLayout.setupWidth(model);
    }

    public void close(View view) {
        finish();
    }

    public void batchImport(View view) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_PERMISSION_MULTI);
        } else {
            pickMultiImage();
        }
    }

    private void pickMultiImage() {
        Matisse.from(this).choose(EnumSet.of(JPEG, PNG)).maxSelectable(mTemplateModel.getAssetsSize()).showSingleMediaType(true).picDetail(false).countable(true).theme(R.style.Matisse_Dracula).forResult(REQUEST_MULTI_IMAGE);
    }

    class LoadTemplateTask extends AsyncTask<String, Void, TemplateModel> {

        @Override
        protected TemplateModel doInBackground(String... strings) {
            TemplateModel templateModel = null;
            try {
                templateModel = new TemplateModel(strings[0], TemplateEditActivity.this);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return templateModel;
        }

        @Override
        protected void onPostExecute(TemplateModel templateModel) {
            if (templateModel != null) {
                mTemplateModel = templateModel;
                mGroupThumbAdapter.setTemplateModel(templateModel);
                for (int i = 1; i <= templateModel.groupSize; i++) { //group从1开始
                    TemplateView templateView = new TemplateView(TemplateEditActivity.this);
                    templateView.setBackgroundColor(Color.BLACK);
                    templateView.setVisibility(i == 1 ? View.VISIBLE : View.GONE);
                    GroupModel groupModel = templateModel.groups.get(i);
                    templateView.setAssetGroup(groupModel);

                    FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                    params.gravity = Gravity.CENTER;

                    mTemplateViews.add(templateView);
                    mContainer.addView(templateView, params);
                }
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_SINGLE_MEDIA && resultCode == RESULT_OK) {
            List<String> strings = Matisse.obtainPathResult(data);
            String path = strings.get(0);

            String extension = MimeTypeMap.getFileExtensionFromUrl(path);
            String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
            if (MimeType.isImage(mimeType)) {
                mModel.setImageAsset(path);
            } else if (MimeType.isVideo(mimeType)) {
                VideoClipActivity.start(this, mModel.size.getWidth(), mModel.size.getHeight(), (float) mModel.getDuration() / mTemplateModel.fps, path, REQUEST_CLIP_VIDEO);
            } else {

            }
        } else if (requestCode == REQUEST_MULTI_IMAGE && resultCode == RESULT_OK) {
            List<String> paths = Matisse.obtainPathResult(data);
            mTemplateModel.setReplaceFiles(paths);
        } else if (requestCode == REQUEST_CLIP_VIDEO && resultCode == RESULT_OK) {
            String path = data.getStringExtra(VideoClipActivity.CLICP_PATH);
            mModel.setVideoPath(path);
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == REQUEST_PERMISSION_SINGLE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pickSingleMedia();
            }
        } else if (requestCode == REQUEST_PERMISSION_MULTI) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pickMultiImage();
            }

        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    @Override
    public void onBackPressed() {
        if (mTextEditLayout.getVisibility() == View.VISIBLE) {
            mTextEditLayout.hide();
        } else {
            super.onBackPressed();
        }
    }
}
