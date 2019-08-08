package com.zhihu.matisse.internal.ui.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.zhihu.matisse.R;
import com.zhihu.matisse.internal.entity.Item;
import com.zhihu.matisse.internal.utils.GlideUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Description:
 * Data：2018/12/13-17:28
 * Author:
 */
public class SelectPicAdapter extends RecyclerView.Adapter<SelectPicAdapter.ViewHolder> {
    private Context mContext;
    private List<Item> mData;

    public SelectPicAdapter(Context context) {
        this.mContext = context;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view;
        view = LayoutInflater.from(mContext).inflate(R.layout.select_pic_item_layout, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        if (mData == null) {
            return;
        }
        Item item = mData.get(position);
        if (item == null) {
            return;
        }

        GlideUtils.loadPicNormal(holder.select_item_iv, item.uri);
    }

    @Override
    public int getItemCount() {
        return mData == null ? 0 : mData.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        ImageView select_item_iv;
        ImageView select_delete_iv;

        public ViewHolder(final View itemView) {
            super(itemView);

            select_item_iv = itemView.findViewById(R.id.select_item_iv);
            select_delete_iv = itemView.findViewById(R.id.select_delete_iv);
            select_delete_iv.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int position = getLayoutPosition();
                    //通知外部回调
                    if (selectPicAdapterListener != null) {
                        selectPicAdapterListener.remove(mData.get(position), mData.size() == 1);
                    }
                    removeItem(position);
                }
            });
        }
    }

    public void setData(List<Item> data) {
        this.mData = data;
        notifyDataSetChanged();
        setTips();
    }

    public void addData(Item item) {
        if (mData == null) {
            mData = new ArrayList<>();
        }
        mData.add(item);
        notifyItemInserted(mData.indexOf(item));
    }

    public void removeItem(int position) {
        if (mData == null || mData.size() < 1) {
            return;
        }
        mData.remove(position);
        notifyItemRemoved(position);
        setTips();
    }

    public interface SelectPicAdapterListener {
        void remove(Item item, boolean isEmpty);

        void move(List<Item> data);

        void setTips(int num);
    }

    public void setSelectPicAdapterListener(SelectPicAdapterListener selectPicAdapterListener) {
        this.selectPicAdapterListener = selectPicAdapterListener;
    }

    private SelectPicAdapterListener selectPicAdapterListener;

    public void moveItem(int fromPosition, int targetPosition) {
        if (fromPosition < targetPosition) {
            for (int i = fromPosition; i < targetPosition; i++) {
                Collections.swap(mData, i, i + 1);
            }
        } else {
            for (int i = fromPosition; i > targetPosition; i--) {
                Collections.swap(mData, i, i - 1);
            }
        }
        if (selectPicAdapterListener != null) {
            selectPicAdapterListener.move(mData);
        }
        notifyItemMoved(fromPosition, targetPosition);
    }

    private void setTips(){
        if(selectPicAdapterListener != null){
            selectPicAdapterListener.setTips(mData.size());
        }

    }
}
