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
import com.example.myapplication.utils.FragmentUtils;
import com.google.android.material.bottomnavigation.BottomNavigationView;

import java.util.regex.Pattern;

/**
 * A simple {@link Fragment} subclass.
 * Use the {@link AddFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class AddFragment extends Fragment {

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;
    private ProductService productService;
    private BottomNavigationView bottomNavigationView;
    private AlertDialog dialog;
    private AlertDialog.Builder builder;

    public AddFragment() {
        // Required empty public constructor
    }

    public AddFragment(ProductService service, BottomNavigationView bottomNavigationView) {
        this.productService = service;
        this.bottomNavigationView = bottomNavigationView;
    }
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment AddFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddFragment newInstance(String param1, String param2) {
        AddFragment fragment = new AddFragment();
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
        View rootView = inflater.inflate(R.layout.fragment_add, container, false);
        Button mSaveButton = rootView.findViewById(R.id.addButton);

        EditText productName = rootView.findViewById(R.id.productNameTextBox);
        EditText serialNumber = rootView.findViewById(R.id.serialNumberTextBox);
        EditText quantity = rootView.findViewById(R.id.quantityTextBox);
        EditText price = rootView.findViewById(R.id.priceTextBox);
        EditText aisle = rootView.findViewById(R.id.aisleTextBox);

        mSaveButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View view) {
                boolean areInputFieldsValid = FragmentUtils.areAddFragmentFieldValuesValid(
                        productName.getText().toString(),
                        serialNumber.getText().toString(),
                        quantity.getText().toString(),
                        price.getText().toString(),
                        aisle.getText().toString()
                );


                new AlertDialog.Builder(getContext())
                        .setTitle("Are you sure?")
                        .setMessage("You are about to add a new product. Do you wish to continue?")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                boolean result;
                                String title, message;

                                if (areInputFieldsValid) {
                                    result = productService.addProduct(new Product(
                                            productName.getText().toString(),
                                            serialNumber.getText().toString(),
                                            Integer.valueOf(quantity.getText().toString()),
                                            Double.valueOf(price.getText().toString()),
                                            aisle.getText().toString()));
                                    title = result ? "Success" : "Error";
                                    message = result ? "The product has been added successfully"
                                            : "There exists a product with the provided serial number.";
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
                        }).show();


            }
        });


        return rootView;
    }
}