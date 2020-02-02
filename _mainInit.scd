s.boot;
s.plotTree

/*
Testing Inscore setup

1. Create adhock network
2. connect to it with IPad
3. find IP in settings on Ipad
4. enter below
*/

//make sure Inscore has correct IP
(
	s.waitForBoot{
		//setup inscore;
		~score = INScore.new("localhost", 7000);

		/*~score = INScore.new("169.254.57.172", 7000); //use IP that the Ipad gives*/

		~numEvents = 5;

		{
			"masterLimiter.scd".loadRelative;
			"SCMIRdata.scd".loadRelative;
			"bufLoad.scd".loadRelative;
			"inscoreSetup.scd".loadRelative;

			s.sync;

			"SynthDefs.scd".loadRelative;

		}.fork;

		"notationSynthFunc.scd".loadRelative;

			{
				//sequence it here
				~cue = CuePlayer.new;

				1.wait;

				"cues.scd".loadRelative;
				"seqCues.scd".loadRelative;

			}.fork;

			"GUI.scd".loadRelative;

			//to check groups
			s.plotTree
	};
)

s.plotTree
s.boot;

//sounds honor uses for each cue
//1. snap pizz/ silver winding scrape close to bridge
//2. muted bow sweeps up and down fingerboard, unpitched
//3. bow bounces, muted or unmuted or harmonic
//4. just play notes
//5. pitched chatoic / single bow bouces / arco/ staccato / glissando
