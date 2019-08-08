package com.qiniu.pili.droid.shortvideo.demo.sxve.model;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PointF;
import android.media.MediaMetadataRetriever;

import com.qiniu.pili.droid.shortvideo.demo.sxve.AssetDelegate;
import com.qiniu.pili.droid.shortvideo.demo.sxve.util.AffineTransform;
import com.qiniu.pili.droid.shortvideo.demo.sxve.util.Size;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.UUID;

public class MediaUiModel extends AssetUi {

    private final int mDuration;
    private final int[] p;
    private final double t;
    private final int[] a;
    private final int r;
    private final float[] s;
    private Bitmap mBitmap;
    private final Matrix mMatrix;
    private final Paint mInitPaint;
    private Matrix mInverseMatrix;
    private Paint mPaint;
    private boolean mIsVideo;
    private String mVideoPath;

    public MediaUiModel(String folder, JSONObject ui, Bitmap bitmap, AssetDelegate delegate, Size size) throws JSONException {
        super(folder, ui, delegate, size);
        mBitmap = bitmap;

        mDuration = ui.getInt("duration");
        p = getIntArray(ui.getJSONArray("p"));
        a = getIntArray(ui.getJSONArray("a"));
        t = ui.getDouble("t");
        r = ui.getInt("r");
        s = getFloatArray(ui.getJSONArray("s"));

        mInitPaint = new Paint();
        mInitPaint.setAntiAlias(true);
        mInitPaint.setFilterBitmap(true);
        mInitPaint.setAlpha((int) (t * 255));

        mInverseMatrix = new Matrix();

        AffineTransform affineTransform = new AffineTransform();
        affineTransform.set(new PointF(a[0], a[1]), new PointF(p[0], p[1]), new PointF(s[0], s[1]), r);
        mMatrix = affineTransform.getMatrix();

    }

    @Override
    public void draw(Canvas canvas, int activeLayer) {
        mPaint = null;

        canvas.drawBitmap(mBitmap, mMatrix, mPaint);

        if (f != null) {
            canvas.drawBitmap(f, 0, 0, mPaint);
        }
    }

    @Override
    public void scroll(float distanceX, float distanceY) {
        if (!mIsVideo) {
            mMatrix.postTranslate(-distanceX, -distanceY);
        }
    }

    @Override
    public void scale(float sx, float sy, float px, float py) {
        if (!mIsVideo) {
            mMatrix.postScale(sx, sx, px, py);
        }
    }

    @Override
    public void rotate(float degrees, float px, float py) {
        if (!mIsVideo) {
            mMatrix.postRotate(degrees, px, py);
        }
    }

    @Override
    public boolean isPointInside(PointF point) {
        mMatrix.invert(mInverseMatrix);
        float[] dst = new float[2];
        mInverseMatrix.mapPoints(dst, new float[]{point.x, point.y});
        return dst[0] >= 0 && dst[0] <= mBitmap.getWidth() && dst[1] >= 0 && dst[1] <= mBitmap.getHeight();
    }

    @Override
    public void singleTap(GroupModel groupModel) {
        mDelegate.pickMedia(this);
    }

    @Override
    public String getSnapPath(String folder) {
        if (!mIsVideo) {
            Bitmap bitmap = Bitmap.createBitmap(size.getWidth(), size.getHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.drawBitmap(mBitmap, mMatrix, mPaint);
            String path = folder + File.separator + UUID.randomUUID() + ".png";
            saveBitmapToPath(bitmap, path);
            return path;
        } else {
            return mVideoPath;
        }
    }

    /**
     * @return 素材时长，单位为帧
     */
    public int getDuration() {
        return mDuration;
    }

    public void setImageAsset(String path) {
        mIsVideo = false;
        mBitmap = BitmapFactory.decodeFile(path);
    }

    public void setVideoPath(String path) {
        mVideoPath = path;
        mIsVideo = true;
        mMatrix.reset();
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        retriever.setDataSource(path);
        mBitmap = retriever.getFrameAtTime();
    }
}
