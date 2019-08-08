package com.qiniu.pili.droid.shortvideo.demo.sxve.adapter;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.qiniu.pili.droid.shortvideo.demo.R;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.Template;

import java.util.ArrayList;
import java.util.List;

public class VeTemplateListAdapter extends RecyclerView.Adapter<VeTemplateListAdapter.TemplateListHolder> {

    private List<Template> mTemplates;

    @NonNull
    @Override
    public TemplateListHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new TemplateListHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_template, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull TemplateListHolder holder, int position) {
        Template template = mTemplates.get(position);
        holder.name.setText(template.name);
        holder.description.setText(template.description);
    }

    @Override
    public int getItemCount() {
        return mTemplates == null ? 0 : mTemplates.size();
    }

    public void setData(ArrayList<Template> templates) {
        mTemplates = templates;
        notifyDataSetChanged();
    }

    class TemplateListHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        public final TextView name;
        public final TextView description;

        public TemplateListHolder(View itemView) {
            super(itemView);

            name = itemView.findViewById(R.id.template_name);
            description = itemView.findViewById(R.id.template_description);

            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (mOnTemplateClickListener != null) {
                mOnTemplateClickListener.onTemplateClick(mTemplates.get(getAdapterPosition()));
            }
        }
    }

    private OnTemplateClickListener mOnTemplateClickListener;

    public interface OnTemplateClickListener {
        void onTemplateClick(Template template);
    }

    public void setOnTemplateClickListener(OnTemplateClickListener onTemplateClickListener) {
        mOnTemplateClickListener = onTemplateClickListener;
    }
}
