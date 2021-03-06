package com.dian.arc.libs;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.dian.arc.libs.custom.FancyButton;
import com.dian.arc.libs.utilities.ArcManager;

public class Chronotype0Fragment extends BaseFragment {

    FancyButton button;

    public Chronotype0Fragment() {

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_chronotype_0, container, false);

        setupDebug(view);

        button = (FancyButton)view.findViewById(R.id.fancybuttonChronotype0);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ArcManager.getInstance().nextFragment();
            }
        });
        return view;
    }



}
