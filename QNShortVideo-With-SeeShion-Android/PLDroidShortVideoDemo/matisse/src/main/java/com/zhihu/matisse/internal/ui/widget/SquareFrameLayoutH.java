package com.zhihu.matisse.internal.ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;

/**
 * Description:
 * Data：2018/12/13-17:39
 * Author:
 */
public class SquareFrameLayoutH extends FrameLayout {
    public SquareFrameLayoutH(Context context) {
        super(context);
    }

    public SquareFrameLayoutH(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(heightMeasureSpec, heightMeasureSpec);
    }
}
