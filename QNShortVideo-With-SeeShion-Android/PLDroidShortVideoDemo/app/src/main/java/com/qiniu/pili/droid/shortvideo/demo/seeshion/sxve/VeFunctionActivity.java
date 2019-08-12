package com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Toast;


import com.qiniu.pili.droid.shortvideo.demo.seeshion.R;
import com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve.adapter.VeTemplateListAdapter;


import java.io.File;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;


import com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve.model.Template;
import com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve.util.AssetsUtils;
import com.shixing.sxvideoengine.License;
import com.zhihu.matisse.Matisse;


import static com.qiniu.pili.droid.shortvideo.demo.seeshion.sxve.VeTemplateListActivity.REQUEST_STORAGE_PERMISSION;
import static com.zhihu.matisse.MimeType.JPEG;
import static com.zhihu.matisse.MimeType.PNG;


public class VeFunctionActivity extends AppCompatActivity {

    public static final String TEMPLATE_FOLDER = "template";
    public static final String DYNAMIC_FOLDER = "dynamic";
    private static final int REQUEST_PREVIEW_SOURCE = 11;
    private View mProgressBar;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ve_sample);
        setTitle("VE功能展示");

        mProgressBar = findViewById(R.id.progress_bar);
        init();

        String license = "Ih0p8+9ix9GqQz401Kcxm8aPajlf1bNhlXzoNGX5z6XEgeMlo2PBMaoHwffFV7bSmLvftYZKK9BX7caxxyQ2n3TUoe9uGDYHm+bkXexADC+i6m9ta+eBdp9ta6LvhuO/lhbOt15zls4Bk4d4vzM+y7b+zALvnf9ItbyspaY9AScMzfm4Mm/KMDLTA/E7kff0N4d6ikY7UoFNh9vkHMVKL+lBSEOfba57M2GQ+9KAXd8hd3Uj3j0T05mNdcY/rBR1hacH8Fkjcd/RbGwKeUemv5rEL8nZXmjmHY7Wxl9arBOwxO8KmkTMx+fk/st3M9IVIDVSH4txCuTxyc+L3/GAdUYDS14c1sgBhpucdJZG5BOL7KfCH2CXTTN/lIfD8IEQSWrCG8sCsDDFDRB+8PtvUQ2icOcpicntjds0+xd2/fBylf25QIj87h14JdE0Z8DYBXzdGS9wYlOIbTh762hbrww9r5b2+ggb49OzNJ8uAilHTImurqXJXz16WtrS4WA+z8sWIqoEMtQ9fPR3q2qAoAy1ts2Hkb8sZZtg40VZ6kW2/swC753/SLW8rKWmPQEn7OQHocI6dn8QzhM8YL6rwlxD8Is3PLEQ9xfF8f9fOAAh25FvoWNMERuLcl46JNgelEQb4G9R+tmz0gz2wSD5059JYFGiNxYdi1UWU7wA21Z9JcrOvnl4DAFhsweaIlZtpJMgf+dPVRVeBwVCN/fU/qHmE3SH768kRZ7eZOlkephCayXiuqWMGfV/3uY39rsB3TfyFoUCdD8t6TqC+7RgoRDLdA9bGBxGbnHz/iJ8vYbpCBoJpAXP3QhgKQ+M44KMWC9FO7peOthoHqnHIS9oAA==";
        License l = License.init(license);
        boolean b = l.isValid();
        Toast.makeText(this, "license: " + b, Toast.LENGTH_SHORT).show();

    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

    }

    private void init() {
        RecyclerView list = findViewById(R.id.list);
        list.setLayoutManager(new LinearLayoutManager(this));
        VeTemplateListAdapter adapter = new VeTemplateListAdapter();
        list.setAdapter(adapter);
        adapter.setOnTemplateClickListener(new VeTemplateListAdapter.OnTemplateClickListener() {
            @Override
            public void onTemplateClick(Template template) {
                if (template.folder != null) {
                    VeTemplateListActivity.start(VeFunctionActivity.this, template.folder, template.name + "演示");
                } else {
                    copyAssets();
                }
            }
        });

        ArrayList<Template> templates = new ArrayList<>();
        templates.add(new Template("标准模板", TEMPLATE_FOLDER, "标准模板是指从After Effects中导出的，固定时间长度，支持固定数量和固定类型素材的视频模板。标准模板能够很好地将设计师的设计能力与用户素材相结合，制作出趣味性、创意性十足的视频内容"));
        templates.add(new Template("动态模板", DYNAMIC_FOLDER, "动态模板是指从After Effects中导出的一种特殊视频模板，它不限制用户使用的素材数量，能够根据用户实际使用的素材数量动态调节最终生成的视频长度。适合制作影集、音乐相册等视频内容"));
        templates.add(new Template("模板实时预览", null, "模板实时预览能够在不需要将模板渲染导出视频人情况下实时预览模板的效果。注意，模板实时预览的性能受手机硬件和模板复杂性的影响。"));
        adapter.setData(templates);
        mProgressBar.setVisibility(View.GONE);
    }

    private void copyAssets() {
        mProgressBar.setVisibility(View.VISIBLE);
        File dir = getExternalFilesDir(DYNAMIC_FOLDER);
        copyTemplate(dir, "Simple");
        copyTemplate(dir, "Album");
        copyAudio("aaa.mp3");
        copyAudio("bbb.mp3");
        mProgressBar.setVisibility(View.GONE);
        if (ContextCompat.checkSelfPermission(VeFunctionActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(VeFunctionActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_STORAGE_PERMISSION);
        } else {
            pickMedia();
        }
    }

    private void copyTemplate(File dir, String name) {
        File file = new File(dir, name);
        if (!file.exists()) {
            AssetsUtils.copyDirFromAssets(this, DYNAMIC_FOLDER + File.separator + name, file.getPath());
        }
    }

    private void copyAudio(String name) {
        File dir = getExternalFilesDir("");
        File file = new File(dir, name);
        if (!file.exists()) {
            AssetsUtils.copyFileFromAssets(this, name, file.getPath());
        }
    }

    private void pickMedia() {
        Matisse.from(this).choose(EnumSet.of(JPEG, PNG), false).showSingleMediaType(true).maxSelectable(100).setMinSelect(3).picDetail(false).countable(true).theme(R.style.Matisse_Dracula).forResult(REQUEST_PREVIEW_SOURCE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_PREVIEW_SOURCE && resultCode == RESULT_OK) {
            List<String> pathList = Matisse.obtainPathResult(data);
            String[] paths = new String[pathList.size()];
            pathList.toArray(paths);

            VeLivePreviewActivity.start(this, paths);
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_STORAGE_PERMISSION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pickMedia();
            }
        }
    }
}
