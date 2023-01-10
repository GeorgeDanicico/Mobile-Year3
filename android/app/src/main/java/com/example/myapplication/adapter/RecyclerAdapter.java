package com.example.myapplication.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.myapplication.R;
import com.example.myapplication.model.Product;

import java.util.ArrayList;

public class RecyclerAdapter extends RecyclerView.Adapter<RecyclerAdapter.MyViewHolder> {
    public interface OnItemClickListener {
        void onItemClick(Product item);
    }

    public interface OnLongClickListener {
        void onLongClick(Product item);
    }

    private ArrayList<Product> productsList;
    private OnItemClickListener listener;
    private OnLongClickListener longListener;
    private int lastPosition = -1;

    public RecyclerAdapter(ArrayList<Product> _pList) {
        this.productsList = _pList;
    }

    public RecyclerAdapter(ArrayList<Product> _pList, OnItemClickListener listener, OnLongClickListener longListener) {
        this.productsList = _pList;
        this.listener = listener;
        this.longListener = longListener;
    }

    public class MyViewHolder extends RecyclerView.ViewHolder {
        private TextView productNameText;
        private TextView serialNumberText;
        private TextView quantityText;
        private TextView priceText;
        private TextView aisleText;

        public MyViewHolder(final View view) {
            super(view);
            productNameText = view.findViewById(R.id.productNameValue);
            serialNumberText = view.findViewById(R.id.serialNumberValue);
        }

        public void bind(final Product item, final OnItemClickListener listener) {
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    listener.onItemClick(item);
                }
            });
        }

        public void bind(final Product item, final OnLongClickListener listener) {
            itemView.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View view) {
                    listener.onLongClick(item);
                    return true;
                }
            });
        }
    }

    @NonNull
    @Override
    public RecyclerAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.list_items, parent, false);

        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerAdapter.MyViewHolder holder, int position) {
        String pName = productsList.get(position).getProductName();
        String sNumber = productsList.get(position).getSerialNumber();

        holder.productNameText.setText(pName);
        holder.serialNumberText.setText(sNumber);
        holder.bind(productsList.get(position), listener);
        holder.bind(productsList.get(position), longListener);
        setAnimation(holder.itemView, position);
    }

    private void setAnimation(View viewToAnimate, int position)
    {
        // If the bound view wasn't previously displayed on screen, it's animated
        if (position > lastPosition)
        {
            Animation animation = AnimationUtils.loadAnimation(viewToAnimate.getContext(), android.R.anim.slide_in_left);
            viewToAnimate.startAnimation(animation);
            lastPosition = position;
        }
    }

    @Override
    public int getItemCount() {
        return productsList.size();
    }
}
