package com.dian.arc.libs;

import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.dian.arc.libs.custom.SymbolButton;
import com.dian.arc.libs.rest.models.SymbolsTest;
import com.dian.arc.libs.rest.models.SymbolsTestSection;
import com.dian.arc.libs.utilities.ArcManager;
import com.dian.arc.libs.utilities.JodaUtil;

import org.joda.time.DateTime;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class SymbolTestFragment extends BaseFragment {

    List<Integer> symbolset = new ArrayList<>(Arrays.asList(
            R.drawable.symbol_0,
            R.drawable.symbol_1,
            R.drawable.symbol_2,
            R.drawable.symbol_3,
            R.drawable.symbol_4,
            R.drawable.symbol_5,
            R.drawable.symbol_6,
            R.drawable.symbol_7));

    SymbolButton buttonTop1;
    SymbolButton buttonTop2;
    SymbolButton buttonTop3;
    SymbolButton buttonBottom1;
    SymbolButton buttonBottom2;
    FrameLayout frameHide;
    Random random = new Random(System.currentTimeMillis());
    List symbols = new ArrayList();
    int iteration = 0;
    boolean paused;
    Handler handler;
    private Runnable runnable = new Runnable() {
        @Override
        public void run() {
            handler.removeCallbacks(runnable);
            saveIteration();
            if(iteration==12) {
                ArcManager.getInstance().getCurrentTestSession().setSymbolsTest(symbolsTest);
                ArcManager.getInstance().nextFragment();
            }else {
                setupNextIteration();
            }
        }
    };

    SymbolsTest symbolsTest;
    SymbolsTestSection symbolsTestSection;

    public SymbolTestFragment() {

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_symbols_test, container, false);
        frameHide = (FrameLayout)view.findViewById(R.id.frameHide);
        handler = new Handler();
        buttonTop1 = (SymbolButton)view.findViewById(R.id.symbolbutton_top1);
        buttonTop2 = (SymbolButton)view.findViewById(R.id.symbolbutton_top2);
        buttonTop3 = (SymbolButton)view.findViewById(R.id.symbolbutton_top3);

        buttonBottom1 = (SymbolButton)view.findViewById(R.id.symbolbutton_bottom1);
        buttonBottom1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                symbolsTestSection.setSelected(1,symbolsTest.getDate());
                handler.post(runnable);
            }
        });

        buttonBottom2 = (SymbolButton)view.findViewById(R.id.symbolbutton_bottom2);
        buttonBottom2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                symbolsTestSection.setSelected(2,symbolsTest.getDate());
                handler.post(runnable);
            }
        });

        symbolsTest = ArcManager.getInstance().getCurrentTestSession().getSymbolsTest();
        setupNextIteration();

        return view;
    }

    private void setupNextIteration(){
        symbolsTestSection = symbolsTest.getSections().get(iteration);
        iteration++;
        symbols.clear();
        symbols.addAll(symbolset);
        int[] set =  new int[8];
        Integer i1;
        Integer i2;
        for(int i=0;i<8;i++){
            i1 = (int)symbols.get(random.nextInt(8));
            i2 = (int)symbols.get(random.nextInt(8));
            boolean run = true;
            while(run){
                if(run) {
                    i2 = (int) symbols.get(random.nextInt(8));
                    if (i1 != i2 && !similar(i1, i2, set)) {
                        run = false;
                    }
                }
            }
            set[i] = i1;
            set[i+1] = i2;
            i++;
        }
        List<List<String>> options = new ArrayList<>();
        List<String> option1 = new ArrayList<>();
        option1.add(getResources().getResourceEntryName(set[0]));
        option1.add(getResources().getResourceEntryName(set[1]));
        List<String> option2 = new ArrayList<>();
        option2.add(getResources().getResourceEntryName(set[2]));
        option2.add(getResources().getResourceEntryName(set[3]));
        List<String> option3 = new ArrayList<>();
        option3.add(getResources().getResourceEntryName(set[4]));
        option3.add(getResources().getResourceEntryName(set[5]));

        options.add(option1);
        options.add(option2);
        options.add(option3);
        symbolsTestSection.setOptions(options);

        buttonTop1.setImages(set[0],set[1]);
        buttonTop2.setImages(set[2],set[3]);
        buttonTop3.setImages(set[4],set[5]);
        int topIndex = random.nextInt(3)*2;
        int c1 = set[topIndex];
        int c2 = set[topIndex+1];
        /*
        if(random.nextInt(2)==0){
            int copy = c1;
            c1 = c2;
            c2 = copy;
        }*/
        List<List<String>> choices = new ArrayList<>();
        List<String> choice1 = new ArrayList<>();
        List<String> choice2 = new ArrayList<>();
        if(random.nextInt(2)==0){
            symbolsTestSection.setCorrect(2);
            choice1.add(getResources().getResourceEntryName(set[6]));
            choice1.add(getResources().getResourceEntryName(set[7]));
            buttonBottom1.setImages(set[6],set[7]);
            choice2.add(getResources().getResourceEntryName(c1));
            choice2.add(getResources().getResourceEntryName(c2));
            buttonBottom2.setImages(c1,c2);
        } else {
            symbolsTestSection.setCorrect(1);
            choice1.add(getResources().getResourceEntryName(c1));
            choice1.add(getResources().getResourceEntryName(c2));
            buttonBottom1.setImages(c1,c2);
            choice2.add(getResources().getResourceEntryName(set[6]));
            choice2.add(getResources().getResourceEntryName(set[7]));
            buttonBottom2.setImages(set[6],set[7]);
        }
        choices.add(choice1);
        choices.add(choice2);

        symbolsTestSection.setChoices(choices);
        symbolsTestSection.setAppearanceTime(JodaUtil.toUtcDouble(DateTime.now())-symbolsTest.getDate());
    }

    private boolean similar(int a1,int a2, int[] set){
        if(a1==a2){
            return true;
        }
        for(int i=0;i<set.length;i++){
            if((a1==set[i] && a2 == set[i+1]) || (a1==set[i+1] && a2 == set[i])) {
                return true;
            }
            i++;
        }
        return false;
    }

    private void saveIteration(){
        symbolsTest.getSections().set(iteration-1,symbolsTestSection);
    }

    @Override
    public void onResume() {
        super.onResume();
        if(paused) {
            ArcManager.getInstance().nextFragment();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        handler.removeCallbacks(runnable);
        paused = true;
    }

}
