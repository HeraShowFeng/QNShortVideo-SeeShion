/*
 * Copyright 2017 Zhihu Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.zhihu.matisse.internal.ui;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.helper.ItemTouchHelper;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.zhihu.matisse.R;
import com.zhihu.matisse.internal.entity.Album;
import com.zhihu.matisse.internal.entity.Item;
import com.zhihu.matisse.internal.entity.SelectionSpec;
import com.zhihu.matisse.internal.model.AlbumMediaCollection;
import com.zhihu.matisse.internal.model.SelectedItemCollection;
import com.zhihu.matisse.internal.ui.adapter.AlbumMediaAdapter;
import com.zhihu.matisse.internal.ui.adapter.SelectPicAdapter;
import com.zhihu.matisse.internal.ui.widget.MediaGridInset;
import com.zhihu.matisse.internal.utils.UIUtils;
import com.zhihu.matisse.ui.MatisseActivity;

import java.util.List;

public class MediaSelectionFragment extends Fragment implements
        AlbumMediaCollection.AlbumMediaCallbacks, AlbumMediaAdapter.CheckStateListener,
        AlbumMediaAdapter.OnMediaClickListener {

    public static final String EXTRA_ALBUM = "extra_album";

    private final AlbumMediaCollection mAlbumMediaCollection = new AlbumMediaCollection();
    private RecyclerView mRecyclerView;
    private AlbumMediaAdapter mAdapter;
    private SelectionProvider mSelectionProvider;
    private AlbumMediaAdapter.CheckStateListener mCheckStateListener;
    private AlbumMediaAdapter.OnMediaClickListener mOnMediaClickListener;

    private RecyclerView select_rv;
    private SelectPicAdapter selectPicAdapter;
    private RelativeLayout select_parent_rl;
    private TextView select_count_tv;

    public static MediaSelectionFragment newInstance(Album album) {
        MediaSelectionFragment fragment = new MediaSelectionFragment();
        Bundle args = new Bundle();
        args.putParcelable(EXTRA_ALBUM, album);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof SelectionProvider) {
            mSelectionProvider = (SelectionProvider) context;
        } else {
            throw new IllegalStateException("Context must implement SelectionProvider.");
        }
        if (context instanceof AlbumMediaAdapter.CheckStateListener) {
            mCheckStateListener = (AlbumMediaAdapter.CheckStateListener) context;
        }
        if (context instanceof AlbumMediaAdapter.OnMediaClickListener) {
            mOnMediaClickListener = (AlbumMediaAdapter.OnMediaClickListener) context;
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_media_selection, container, false);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        mRecyclerView = view.findViewById(R.id.recyclerview);

        select_parent_rl = view.findViewById(R.id.select_parent_rl);
        select_rv = view.findViewById(R.id.select_rv);
        select_count_tv = view.findViewById(R.id.select_count_tv);

        //点击确定
        view.findViewById(R.id.select_confirm_tv).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MatisseActivity) getActivity()).selectPics();
            }
        });
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        Album album = getArguments().getParcelable(EXTRA_ALBUM);

        mAdapter = new AlbumMediaAdapter(getContext(),
                mSelectionProvider.provideSelectedItemCollection(), mRecyclerView);
        mAdapter.setShowSelectFra(new AlbumMediaAdapter.showSelectFra() {
            @Override
            public void selectChange(List<Item> itemList) {
                setChangedValue(itemList);
            }
        });
        mAdapter.registerCheckStateListener(this);
        mAdapter.registerOnMediaClickListener(this);
        mRecyclerView.setHasFixedSize(true);

        int spanCount;
        SelectionSpec selectionSpec = SelectionSpec.getInstance();
        if (selectionSpec.gridExpectedSize > 0) {
            spanCount = UIUtils.spanCount(getContext(), selectionSpec.gridExpectedSize);
        } else {
            spanCount = selectionSpec.spanCount;
        }
        mRecyclerView.setLayoutManager(new GridLayoutManager(getContext(), spanCount));

        int spacing = getResources().getDimensionPixelSize(R.dimen.media_grid_spacing);
        mRecyclerView.addItemDecoration(new MediaGridInset(spanCount, spacing, false));
        mRecyclerView.setAdapter(mAdapter);
        mAlbumMediaCollection.onCreate(getActivity(), this);
        mAlbumMediaCollection.load(album, selectionSpec.capture);


        select_rv.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false));
        select_rv.setHasFixedSize(true);
        selectPicAdapter = new SelectPicAdapter(getContext());
        select_rv.addItemDecoration(new RecyclerView.ItemDecoration() {
            @Override
            public void onDraw(Canvas c, RecyclerView parent, RecyclerView.State state) {
                super.onDraw(c, parent, state);
            }

            @Override
            public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
                super.getItemOffsets(outRect, view, parent, state);
                outRect.right = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 10, getResources().getDisplayMetrics());
            }
        });
        selectPicAdapter.setSelectPicAdapterListener(new SelectPicAdapter.SelectPicAdapterListener() {
            @Override
            public void remove(Item item, boolean isEmpty) {
                mAdapter.removeItem(item);
                if (isEmpty) {
                    setSelectRvVisible(false);
                }
            }

            @Override
            public void move(List<Item> data) {
                mAdapter.move(data);
            }

            @Override
            public void setTips(int num) {
                setSelectTips(num);
            }
        });
        select_rv.setAdapter(selectPicAdapter);

        ItemTouchHelper itemTouchHelper = new ItemTouchHelper(new ItemTouchHelper.Callback() {
            @Override
            public int getMovementFlags(RecyclerView recyclerView, RecyclerView.ViewHolder viewHolder) {
                if (recyclerView.getLayoutManager() instanceof LinearLayoutManager) {
                    int dragFlags = ItemTouchHelper.LEFT | ItemTouchHelper.RIGHT;
                    int swipFlags = 0;
                    return makeMovementFlags(dragFlags, swipFlags);
                } else {
                    return 0;
                }
            }

            @Override
            public boolean onMove(RecyclerView recyclerView, RecyclerView.ViewHolder viewHolder, RecyclerView.ViewHolder target) {
                int fromPosition = viewHolder.getAdapterPosition();
                int targetPosition = target.getAdapterPosition();

                replaceSelect(fromPosition, targetPosition);
                return true;
            }

            @Override
            public void onSwiped(RecyclerView.ViewHolder viewHolder, int direction) {

            }
        });
        itemTouchHelper.attachToRecyclerView(select_rv);

        selectPicAdapter.setData(mAdapter.getSelectData());
        if (mAdapter.getSelectData() != null && mAdapter.getSelectData().size() > 0) {
            setSelectRvVisible(true);
        }
    }

    //移动图片
    private void replaceSelect(int fromPosition, int targetPosition) {
        selectPicAdapter.moveItem(fromPosition, targetPosition);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        mAlbumMediaCollection.onDestroy();
    }

    public void refreshMediaGrid() {
        mAdapter.notifyDataSetChanged();
    }

    public void refreshSelection() {
        mAdapter.refreshSelection();
    }

    @Override
    public void onAlbumMediaLoad(Cursor cursor) {
        mAdapter.swapCursor(cursor);
    }

    @Override
    public void onAlbumMediaReset() {
        mAdapter.swapCursor(null);
    }

    @Override
    public void onUpdate() {
        // notify outer Activity that check state changed
        if (mCheckStateListener != null) {
            mCheckStateListener.onUpdate();
        }
    }

    @Override
    public void onMediaClick(Album album, Item item, int adapterPosition) {
        if (mOnMediaClickListener != null) {
            mOnMediaClickListener.onMediaClick((Album) getArguments().getParcelable(EXTRA_ALBUM),
                    item, adapterPosition);
        }
    }

    public interface SelectionProvider {
        SelectedItemCollection provideSelectedItemCollection();
    }

    private void setSelectRvVisible(boolean visible) {
        select_parent_rl.setVisibility(visible ? View.VISIBLE : View.GONE);

        int paddingBottom = 0;
        //设置padding
        if (visible) {
            paddingBottom = (int) getResources().getDimension(R.dimen.select_relative_layout_height);
        } else {
            paddingBottom = 0;
        }
        mRecyclerView.setPadding(0, 0, 0, paddingBottom);
    }


    private void setChangedValue(List<Item> itemList) {
        selectPicAdapter.setData(itemList);
        setSelectRvVisible(itemList != null && itemList.size() > 0);
    }

    public void setSelectTips(int selectNum) {
        int maxNum = SelectionSpec.getInstance().maxSelectable;

        int fir_sta_pos = 3;                                     // 第一个数字起始index
        int fir_end_pos = String.valueOf(selectNum).length() + 3;// 第一个数字结尾index
        int sec_sta_pos = fir_end_pos + 4;                                   // 第二个数字起始index
        int sec_end_pos = String.valueOf(maxNum).length() + sec_sta_pos;// 第二个数字结尾index
        ForegroundColorSpan firstColorSpan = new ForegroundColorSpan(getResources().getColor(R.color.normal_yellow));
        ForegroundColorSpan secondColorSpan = new ForegroundColorSpan(getResources().getColor(R.color.normal_yellow));

        String tips = String.format(getString(R.string.select_tips), selectNum, maxNum);
        SpannableStringBuilder spannableStringBuilder = new SpannableStringBuilder(tips);

        spannableStringBuilder.setSpan(firstColorSpan, fir_sta_pos, fir_end_pos, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannableStringBuilder.setSpan(secondColorSpan, sec_sta_pos, sec_end_pos, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        select_count_tv.setText(spannableStringBuilder);
    }
}
