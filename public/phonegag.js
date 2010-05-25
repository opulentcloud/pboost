function onInput(s, type, obj, arg)
{
	try
	{
		// if(type == "dtmf")
		// {
			// console_log("info", "DTMF digit: "+s.name+" ["+obj.digit+"] len ["+obj.duration+"]\n");
		// }
		// else if(type == "event" && session.getVariable("vmd_detect") == "TRUE")
		// {
			// console_log("info", "Voicemail Detected\n");

 
			var db = new ODBC("phonegag", "root", "somepass");
			db.connect();
 			var sql = "select * from calls where call_id = " + session.getVariable('call_id');
			if (!db.query(sql)) {
				console_log("info", "DB Select Failure\n");
   				session.hangup();
			}

			while(db.nextRow()) {
   				var row = db.getData();

	
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/Names1/" + row['target_name'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/2" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/Friends1/" + row['mutual_friend'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/3" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/Location/" + row['location'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/4" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/Friends2/" + row['mutual_friend'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/5" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/DescribeHim/" + row['describe'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/6" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/DescribeHimMore/" + row['describe_more'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/7" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/Names2/" + row['target_name'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/8" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/Friends3/" + row['callers_name'] + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/9" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/10" + ".wav");
				session.streamFile("/var/lib/asterisk/sounds/voice_rec/static/11" + ".wav");

				session.hangup();

			}
	
		// }
		
	}
	catch(e)
	{
		console_log("err", e + "\n");
	}
	return true;
}


use("ODBC");

session.answer();
session.execute("vmd", "start");
while(session.ready())
{
	session.streamFile("/usr/local/freeswitch/sounds/silence.wav", onInput);
	session.streamFile("/usr/local/freeswitch/sounds/silence.wav", onInput);
	session.streamFile("/usr/local/freeswitch/sounds/silence.wav", onInput);
}


