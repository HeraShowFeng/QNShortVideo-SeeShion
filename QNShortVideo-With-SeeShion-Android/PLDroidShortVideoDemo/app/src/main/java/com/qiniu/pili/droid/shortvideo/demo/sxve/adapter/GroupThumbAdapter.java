package com.qiniu.pili.droid.shortvideo.demo.sxve.adapter;

import android.graphics.Color;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;

import com.qiniu.pili.droid.shortvideo.demo.sxve.model.TemplateModel;
import com.qiniu.pili.droid.shortvideo.demo.sxve.view.GroupThumbView;

public class GroupThumbAdapter extends RecyclerView.Adapter<GroupThumbAdapter.GroupThumbHolder> {
    private TemplateModel mTemplateModel;
    private int mSelectedItem;
    private OnItemSelectedListener mOnItemSelectedListener;

    public GroupThumbAdapter() {
    }

    public GroupThumbAdapter(TemplateModel templateModel) {
        mTemplateModel = templateModel;
    }

    @NonNull
    @Override
    public GroupThumbHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        GroupThumbView groupThumbView = new GroupThumbView(parent.getContext());
        groupThumbView.setBackgroundColor(Color.BLACK);
        return new GroupThumbHolder(groupThumbView);
    }

    @Override
    public void onBindViewHolder(@NonNull GroupThumbHolder holder, int position) {
        GroupThumbView thumbView = (GroupThumbView) holder.itemView;
        thumbView.setAssetGroup(mTemplateModel.groups.get(position + 1));
        thumbView.setSelected(position == mSelectedItem);
    }

    @Override
    public int getItemCount() {
        return mTemplateModel == null ? 0 : mTemplateModel.groupSize;
    }

    public void setTemplateModel(TemplateModel templateModel) {
        mTemplateModel = templateModel;
        notifyDataSetChanged();
    }

    class GroupThumbHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        public GroupThumbHolder(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            int position = getAdapterPosition();
            if (position != mSelectedItem) {
                int lastItem = mSelectedItem;
                mSelectedItem = position;
                notifyItemChanged(lastItem);
                notifyItemChanged(mSelectedItem);

                if (mOnItemSelectedListener != null) {
                    mOnItemSelectedListener.onItemSelected(mSelectedItem);
                }
            }
        }
    }

    public interface OnItemSelectedListener {
        /**
         * 选择模板中要替换位置的回调
         *
         * @param index
         */
        void onItemSelected(int index);
    }

    public void setOnItemSelectedListener(OnItemSelectedListener onItemSelectedListener) {
        mOnItemSelectedListener = onItemSelectedListener;
    }
}
