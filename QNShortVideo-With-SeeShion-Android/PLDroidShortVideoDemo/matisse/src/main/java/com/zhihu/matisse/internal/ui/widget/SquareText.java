package com.zhihu.matisse.internal.ui.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;

import com.zhihu.matisse.R;

/**
 * Description:方形 textView(属性写死 有需要在修改)
 * Data：2018/12/13-11:58
 * Author:sjq
 */
public class SquareText extends View {
    private float mDensity;
    private Paint mBackPaint;
    private TextPaint mTextPaint;
    private static final int SIZE = 20; // dp
    private int textSize = 12;
    private int textNum;

    public SquareText(Context context) {
        super(context);
        init(context);
    }

    public SquareText(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    private void init(Context context) {
        mDensity = context.getResources().getDisplayMetrics().density;

        //浅黄色背景
        mBackPaint = new Paint();
        mBackPaint.setAntiAlias(true);
        mBackPaint.setStyle(Paint.Style.FILL);
        mBackPaint.setColor(getResources().getColor(R.color.normal_yellow));

        //黑色字体
        mTextPaint = new TextPaint();
        mTextPaint.setAntiAlias(true);
        mTextPaint.setColor(getResources().getColor(R.color.black));
        mTextPaint.setTextSize(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, textSize, getResources().getDisplayMetrics()));
    }


    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int size = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, SIZE, getResources().getDisplayMetrics());
        setMeasuredDimension(size, size);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        canvas.drawColor(getResources().getColor(R.color.normal_yellow));

        String text = String.valueOf(textNum);
        int baseX = (int) (getWidth() - mTextPaint.measureText(text)) / 2;
        int baseY = (int) (getHeight() - mTextPaint.descent() - mTextPaint.ascent()) / 2;
        canvas.drawText(text, baseX, baseY, mTextPaint);
    }

    public void setTextNum(int num) {
        this.textNum = num;
        invalidate();
    }
}
