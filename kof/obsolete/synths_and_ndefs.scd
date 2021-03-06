

s.boot;
s.freeAll;

//////////////////// defs ////////////////////////////////////////////////

(
    Ndef(\mod).quant = 2.0;
    Ndef(\mod,{Splay.kr(Select.kr(Stepper.kr(Impulse.kr(1/4/(1..8))),1+[0.5,0.75,0.25,1/2,1/4,-0.25,-0.5,1,1].scramble * 0.25pi) )});


    SynthDef(\kick,{|amp = 0.2,freq = 8000|
                    var sig,env1,env2;
                    env1 = EnvGen.ar(Env.new([0,1,0],[{ExpRand(0.01,0.12)}!2,{ExpRand()}!2],[-3,3]),doneAction:2);
                    env2 = EnvGen.ar(Env.new([freq,432/8pi,432/2pi],[0.015,0.02],[-3,3]));
                    sig = Vibrato.ar(SinOsc.ar(env2+([0.01,0]) + LFSaw.ar(env2*1.5)) * env1,[4,5,6,7],0.02);

                    Out.ar(0,Splay.ar(sig,1,amp));


                   }).add;

    SynthDef(\hiss,{|amp = 0.2,freq = 800|
                    var sig,env1,env2;
                    env1 = EnvGen.ar(Env.new([0,1,0],[0.02,{ExpRand(0.2,0.4)}!2],[-3,3]),doneAction:2);
                    sig = Vibrato.ar(HPF.ar(WhiteNoise.ar(amp!2),freq) * env1,[4,5,6,7]+1,0.02);

                    Out.ar(0,Splay.ar(sig,1,amp));


                   }).add;


    SynthDef(\tone,{|freq = 432, amp = 0.2, dur = 1, modd = 1|
                    var env1,env2,env3,sig;
                    env1 = EnvGen.ar(Env.new([0,1,0],[0.02,dur/8],[-3,3]));
                    env2 = EnvGen.ar(Env.new([0,1,0],[dur/16,dur],[3,-3]));
                    env3 = EnvGen.ar(Env.new([0,1,0],[dur,dur*2],[-1,3]),doneAction:2);
                    sig = SinOsc.ar(freq*Ndef(\mod).kr+((1.0001*(1..8))/1.0) ) * env1;
                    sig = LFSaw.ar(freq*Ndef(\mod).kr*(2)+((1.01*(1..8))/4.0) ) * env2 + sig;
                    sig = LFTri.ar(freq*Ndef(\mod).kr/2+((1.01*(1..8))/1.0) ) * env3 + sig + BrownNoise.ar(0.01*modd);


                    Out.ar(0,Splay.ar(sig,0.5,amp));
                   }).add;

    SynthDef(\tone2,{|freq = 432, amp = 0.2, dur = 1, modd = 1|
                    var env1,env2,env3,sig;
                    env1 = EnvGen.ar(Env.new([0,1,0],[0.02,dur/8],[-3,3]));
                    env2 = EnvGen.ar(Env.new([0,1,0],[dur/16,dur],[3,-3]));
                    env3 = EnvGen.ar(Env.new([0,1,0],[dur,dur*2],[-1,3]),doneAction:2);
                    sig = LFSaw.ar(freq*Ndef(\mod).kr+((1.01*(1..8))/1.0) ) * env1;
                    sig = SinOsc.ar(freq*Ndef(\mod).kr*(2)+((1.0001*(1..8))/4.0) ) * env2 + sig;
                    sig = LFTri.ar(freq*Ndef(\mod).kr/2+((1.00001*(1..8))/1.0) ) * env3 + sig + BrownNoise.ar(0.01*modd);


                    Out.ar(0,Splay.ar(sig,0.5,amp));
                   }).add;


)


///////////// binds //////////////////////////////////////////////////////


(

    Pdef(\melod,{
        var a = 0;
        Ppar([
            Pbind(
                \instrument, \tone2,
                \dur, Pseq([1,1,1/2]*1/8,inf),
                \freq, Pseq(([60,72,67]-12).midicps,inf),
                \amp, Pwhite(0.001,0.055,inf)
            ),
            Pbind(
                \instrument, \tone,
                \dur, Pseq([1,1,1/2,1/4,2,4,8],inf),
                \freq, Pseq(([60,65,69]-24).midicps,inf),
                \amp, Pwhite(0.001,0.2,inf)
            ),
            Pbind(
                \instrument, \tone,
                \dur, 16,
                \freq, Pseq(([60,65,69]-12).midicps,inf),
                \modd, Pxrand([1,2,4,1/2,1/4],inf)
            ),
            Pbind(
                \instrument, \tone2,
                \dur, 8,
                \freq, Pxrand(([60,65,69]+24).midicps,inf),
                \modd, Pxrand([1,2,4,1/2,1/4],inf)
            ),
            Pbind(
                \instrument, \tone,
                \dur, 32,
                \freq, Pxrand(([60,65,69]-36).midicps,inf),
                \modd, Pxrand([1,2,4,1/2,1/4],inf)

            )])
    }).play(quant:2);


    Pdef(\beat,{
        Ppar([
            Pbind(
                \instrument, \kick,
                \freq, Pseq([1,1,2,4]*8000,inf),
                \dur, Pseq([1,1,1,1/2,1/2]/4,inf),
                \amp, Pwhite(0.1,0.4,inf)
            ),
            Pbind(
                \instrument, \hiss,
                \freq, Pwhite(4000,12000,inf),
                \dur, Pseq([1,1,1,1/2,1/2]/8,inf),
                \amp, Pwhite(0.1,0.7,inf)
            )])
        }).play(quant:2);
    )


//already done for Ikaria ^^ sweet!
