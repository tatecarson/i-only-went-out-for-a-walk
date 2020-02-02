~m = GRHMonome128.new;

//start comp
~start=GRButton(~m, 0@5, 3, 3); // create a bigger button in the top-right corner
~start.action = { |view, value|
	if(value,
	  {	~violinInput = Synth(\violin);
			{~cue.trigger(1)}.defer;
			~synthGroup = Group.new;
			s.record;
			},
	  {~violinInput.free; ~synthGroup.free; s.stopRecording}
	  )
};

//trigger cues
~trig = GRHToggle(~m, 0@0, 8, 1);
~trig.action = { |view, value| {~cue.trigger(value+1)}.defer };

~violinAmp =GRVToggle(~m, 14@0, 2, 8).valuesAreInverted_(true).value_(7);
~violinAmp.action = { |view, value|
	~violinInput.set(\amp, value.linlin(0.0, 7, 0.0, 2.5).postln)
};
