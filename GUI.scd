//start comp GUI
var w, startButton, testInscore, text;
var ampControl, violin;
var indicator, updateIndicator;
var cmdPeriodFunc;
var bus = Bus.control();

//just for violin reinforcement when there is no mixer and
//sending to GUI for metering
SynthDef(\violin, {|out = 0, amp = 1, pan = 0|
  var sig, micAmp;
  sig = SoundIn.ar(0);
  micAmp = Amplitude.kr(sig);
  sig = Pan2.ar(sig, pan, amp);
  Out.kr(bus, micAmp);
  Out.ar(out, sig);
}).add;

Window.closeAll;

// make the window
w = Window("Start", Rect(20, 400, 160, 375));
w.front; // make window visible and front window.
w.onClose_(updateIndicator.stop);
w.view.decorator = FlowLayout(w.view.bounds, 2@2, 20@2);

startButton = Button(w, 150 @ 50);
startButton.states = [
  ["Start", Color.black, Color.green(0.7)],
  ["Stop", Color.white, Color.red(0.7)]
];
startButton.action = {|view|
    if (view.value == 1) {

    {  //set synth Group
  		~synthGroup = ~numEvents.collect{Group.new}; //so you can free before next cue

      0.5.wait;

      Tdef(\seq).play;
      violin = Synth(\violin, [\amp, 0.6] );

      0.5.wait;

      //make sure notation looks ok
      ~score.scale("/myScore", 1, 0.8);
      ~score.move("/myScore", 1, 0.0, -0.2);
      ~score.move("/myText", 1, 0.0, 0.4);
      ~score.scale("/myText", 1, 6.0);
      }.fork;
    } {
      //stop seq
      Tdef(\seq).stop;

      //stop timeline
      ~cue.clock.clear;

      //free violin
      violin.free;
      violin = nil;
      ~melDens = 1; //reset to 1
      ~synthGroup.do{|item| item.free}; //free groups

      //make sure notation looks ok
      ~score.scale("/myScore", 1, 0.8);
      ~score.move("/myScore", 1, 0.0, -0.2);
      ~score.move("/myText", 1, 0.0, 0.4);
      ~score.scale("/myText", 1, 6.0);
    };
};

w.view.decorator.nextLine;

testInscore = Button(w, 150 @ 50);
testInscore.states = [
  ["Test Inscore", Color.black, Color.green(0.7)],
  ["Clear Test", Color.white, Color.red(0.7)]
];
testInscore.action = {|view|
    if (view.value == 1) {
      ~score.line;
    } {
      ~score.reset;
    };
};
/*indicator = LevelIndicator(w, 60 @ 300)
.warning_(0.5)
.critical_(0.7)
.background_(Color.cyan)
.numTicks_(12)
.numMajorTicks_(3)
.drawsPeak_(true);

//update indicator value
updateIndicator = fork{
  loop{
    bus.get({
      arg value;
      {
        indicator.value_(value);
        indicator.peakLevel_(value);
      }.defer;
    });
    0.1.wait;
  }
};

ampControl = EZFancySlider(w, 60 @ 300, "Amp ", \db,
  {|ez| violin.set(\amp, ez.value.dbamp )}, -6, unitWidth:30, numberWidth: 60, layout: \vert)
    .setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey, Color.white, Color.yellow);*/

text = StaticText(w, 150 @ 20)
.string_("Press Spacebar to start");

// set start button to zero upon a cmd-period
cmdPeriodFunc = { startButton.value = 0; violin.free; ~synthGroup.do{|item| item.free};};
CmdPeriod.add(cmdPeriodFunc);
