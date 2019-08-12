package com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.SeekBar;


import com.qiniu.pili.droid.shortvideo.demo.seeshion.R;
import com.qiniu.pili.droid.shortvideo.demo.seeshion.activity.PlaybackActivity;
import com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve.view.SXProgressDialog;
import com.shixing.sxvideoengine.SXPlayerSurfaceView;
import com.shixing.sxvideoengine.SXRenderListener;
import com.shixing.sxvideoengine.SXTemplate;
import com.shixing.sxvideoengine.SXTemplatePlayer;
import com.shixing.sxvideoengine.SXTemplateRender;

import java.io.File;


public class VeLivePreviewActivity extends AppCompatActivity {

    private SXTemplatePlayer mPlayer;
    private int currentTemplate = 1;
    private SXPlayerSurfaceView mPlayerView;
    private String[] mSources;
    private String mTemplate1Folder;
    private String mTemplate2Folder;
    private Button mPlayBtn;
    private int mDuration;
    private SeekBar mSeekBar;
    private String mAudio1Path;
    private String mAudio2Path;
    private String mCurrentAudioPath;
    private SXProgressDialog mDialog;
    private SXTemplatePlayer.PlayStateListener mListener = new SXTemplatePlayer.PlayStateListener() {
        @Override
        public void onProgressChanged(final int frame) {
            mPlayerView.post(new Runnable() {
                @Override
                public void run() {
                    mSeekBar.setProgress(frame);
                }
            });
        }

        @Override
        public void onFinish() {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mPlayBtn.setText("播放");
                }
            });
        }
    };

    public static void start(Context context, String[] source) {
        Intent starter = new Intent(context, VeLivePreviewActivity.class);
        starter.putExtra("source", source);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ve_live_preview);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        setTitle("实时模板预览");

        mSources = getIntent().getStringArrayExtra("source");

        File folder = getExternalFilesDir("dynamic");
        mTemplate1Folder = folder + "/Simple";
        mTemplate2Folder = folder + "/Album";

        File dir = getExternalFilesDir("");
        mAudio1Path = new File(dir, "aaa.mp3").getPath();
        mAudio2Path = new File(dir, "bbb.mp3").getPath();

        mPlayBtn = findViewById(R.id.btn_play);
        mPlayerView = findViewById(R.id.player_surface_view);
        mSeekBar = findViewById(R.id.seek_bar);

        mPlayerView.setPlayCallback(mListener);

        switchTemplate(mTemplate1Folder);

        mSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (fromUser) {
                    mPlayer.seek(progress);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_live_preview, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        } else if (item.getItemId() == R.id.render) {
            render();
        }
        return super.onOptionsItemSelected(item);
    }

    private void render() {
        mPlayer.pause();
        mPlayBtn.setText("播放");
        if (mDialog == null) {
            mDialog = new SXProgressDialog();
        }
        mDialog.show(getSupportFragmentManager(), mDialog.getClass().getSimpleName());
        SXTemplate template = new SXTemplate(currentTemplate == 1 ? mTemplate1Folder : mTemplate2Folder, SXTemplate.TemplateUsage.kForRender);
        template.setReplaceableFilePaths(mSources);
        template.commit();
        final String outputFilePath = getOutputFilePath();
        SXTemplateRender render = new SXTemplateRender(template, mCurrentAudioPath, outputFilePath);
        render.setBitrateFactor(0.5f);
        render.setRenderListener(new SXRenderListener() {
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
                PlaybackActivity.start(VeLivePreviewActivity.this, outputFilePath);
            }

            @Override
            public void onCancel() {

            }
        });
        render.start();
    }

    public String getOutputFilePath() {
        return getExternalFilesDir("video") + File.separator + System.currentTimeMillis() + ".mp4";
    }

    public void template1(View view) {
        if (currentTemplate == 1) {
            return;
        }
        currentTemplate = 1;
        switchTemplate(mTemplate1Folder);
    }

    public void template2(View view) {
        if (currentTemplate == 2) {
            return;
        }
        currentTemplate = 2;
        switchTemplate(mTemplate2Folder);
    }

    private void switchTemplate(String template1Folder) {
        SXTemplate template = new SXTemplate(template1Folder, SXTemplate.TemplateUsage.kForPreview);
        template.setReplaceableFilePaths(mSources);
        template.commit();
        mDuration = template.realDuration();
        mSeekBar.setMax(mDuration);
        mPlayer = mPlayerView.setTemplate(template);
        mPlayBtn.setText("播放");
        mCurrentAudioPath = null;
        mSeekBar.setProgress(0);
    }

    public void replaceAudio(View view) {
        mCurrentAudioPath = mAudio2Path.equals(mCurrentAudioPath) ? mAudio1Path : mAudio2Path;
        mPlayer.replaceAudio(mCurrentAudioPath);
    }

    public void playOrPause(View view) {
        if (mPlayer == null) {
            return;
        }
        if (mPlayer.isPlaying()) {
            mPlayBtn.setText("播放");
            mPlayer.pause();
        } else {
            mPlayBtn.setText("暂停");
            mPlayer.start();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mPlayer.stop();
    }
}
