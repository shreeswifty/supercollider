import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput input;
FFT fftL,fftR;

void setup()
{
  size(512, 800, P2D);

  frameRate(100);

  minim = new Minim(this);

  input = minim.getLineIn(Minim.STEREO, 2048);
  input.mute();

  fftL = new FFT( input.bufferSize(), input.sampleRate() );
  fftR = new FFT( input.bufferSize(), input.sampleRate() );

  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into three bands
  // this should result in 30 averages
  fftL.logAverages( 22, 256 );
  fftR.logAverages( 22, 256 );

  background(0);

  println(fftL.specSize());

}

void draw()
{
  stroke(255);

  fftL.forward( input.left );
  fftR.forward( input.right );

  for(int i = 0; i < fftL.specSize(); i++)
  {
    float valL = constrain(fftL.getBand(i)*25,0,255); 
    float valR = constrain(fftR.getBand(i)*25,0,255); 
    float x = map(i,0,fftL.specSize(),0,width);

    stroke(valL,0,0,12);
    line(x,height,x,height-1);
    stroke(0,valR,0,12);
    line(x,height,x,height-1);}
  image(g,0,-1);

}


void stop()
{
  input.close();
  minim.stop();
  super.stop();
}
