package com.example.myapplication.ui;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.example.myapplication.R;
import com.example.myapplication.model.Product;
import com.example.myapplication.service.ProductService;
import com.google.android.material.bottomnavigation.BottomNavigationView;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link DeleteFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class DeleteFragment extends Fragment {

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;
    private ProductService productService;
    private BottomNavigationView bottomNavigationView;

    public DeleteFragment() {
        // Required empty public constructor
    }

    public DeleteFragment(ProductService service, BottomNavigationView bottomNavigationView) {
        this.productService = service;
        this.bottomNavigationView = bottomNavigationView;
    }
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment DeleteFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static DeleteFragment newInstance(String param1, String param2) {
        DeleteFragment fragment = new DeleteFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_delete, container, false);

        Button mDeleteButton = rootView.findViewById(R.id.deleteButton);

        EditText serialNumber = rootView.findViewById(R.id.serialNumberTextBoxDelete);

        mDeleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean isInputFieldValid = !serialNumber.getText().equals("");

                new AlertDialog.Builder(getContext())
                        .setTitle("Are you sure")
                        .setMessage("You are about to delete a product. Do you wish to continue?")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                boolean result;
                                String title, message;
                                if (isInputFieldValid) {
                                    result = productService.deleteProduct(serialNumber.getText().toString());
                                    title = result ? "Success" : "Error";
                                    message = result ? "The product has been deleted successfully"
                                            : "Invalid Serial Number";
                                } else {
                                    title = "Error";
                                    message = "Invalid fields";
                                    result = false;
                                }

                                new AlertDialog.Builder(getContext())
                                        .setTitle(title)
                                        .setMessage(message)
                                        .show();

                                if (result) {
                                    bottomNavigationView.setSelectedItemId(R.id.home);
                                    FragmentTransaction ft = getFragmentManager().beginTransaction();
                                    ft.replace(R.id.container, new HomeFragment(productService, bottomNavigationView));
                                    ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
                                    ft.addToBackStack(null);
                                    ft.commit();
                                }
                            }
                        })
                        .setNegativeButton("CANCEL", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {

                            }
                        })
                        .show();
            }
        });

        return rootView;
    }
}