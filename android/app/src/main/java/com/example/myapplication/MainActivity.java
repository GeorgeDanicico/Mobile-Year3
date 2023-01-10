package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.example.myapplication.databinding.ActivityMainBinding;
import com.example.myapplication.service.ProductService;
import com.example.myapplication.service.impl.ProductServiceImpl;
import com.example.myapplication.ui.AddFragment;
import com.example.myapplication.ui.DeleteFragment;
import com.example.myapplication.ui.EditFragment;
import com.example.myapplication.ui.HomeFragment;
import com.google.android.material.bottomnavigation.BottomNavigationView;

public class MainActivity extends AppCompatActivity {

    ActivityMainBinding binding;

    @SuppressLint("NonConstantResourceId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        ProductService service = new ProductServiceImpl();

        BottomNavigationView bottomNavigationView = binding.bottomNavigation;

        replaceFragment(new HomeFragment(service, bottomNavigationView));

        bottomNavigationView.setOnItemSelectedListener(item -> {
            switch(item.getItemId()) {
                case R.id.home:
                    replaceFragment(new HomeFragment(service, bottomNavigationView));
                    break;
                case R.id.add:
                    replaceFragment(new AddFragment(service, bottomNavigationView));
                    break;
                case R.id.delete:
                    replaceFragment(new DeleteFragment(service, bottomNavigationView));
                    break;
                case R.id.edit:
                    replaceFragment(new EditFragment(service, bottomNavigationView));
                    break;
                default:
                    System.out.println(item.getItemId());
                    break;
            }

            return true;
        });
    }

    private void switchActivity(AppCompatActivity appCompatActivity) {
        Intent switchActivityIntent = new Intent(this, appCompatActivity.getClass());
        startActivity(switchActivityIntent);
    }

    private void replaceFragment(Fragment fragment) {
        FragmentManager fragmentManager = getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.replace(R.id.container, fragment);
        fragmentTransaction.commit();

    }
}