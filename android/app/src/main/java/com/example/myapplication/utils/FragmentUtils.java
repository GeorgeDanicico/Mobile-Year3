package com.example.myapplication.utils;

import java.util.regex.Pattern;

public class FragmentUtils {

    public static boolean areAddFragmentFieldValuesValid(String productName, String serialNumber, String quantity,
                                                         String price, String aisle) {
        Pattern pattern = Pattern.compile("-?\\d+(\\.\\d+)?");

        return !productName.equals("") && !serialNumber.equals("") && !quantity.equals("") &&
                !price.equals("") && !aisle.equals("") && pattern.matcher(price).matches()
                && pattern.matcher(quantity).matches();
    }
}
