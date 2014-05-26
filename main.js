	function Transpose_Email(userid,domain,subject)
	{
		var email = domain +'@' + userid;
		var TempBefore = '';
		var TempAfter = '';
		var NewString = '';
		var Start = 0;
		
		var WhereHash = email.indexOf ('@');
		for (Count = 1; Count <= WhereHash; Count ++)
		{
			TempBefore += email.substring (Start, Count);
			Start++
		}
		Start = WhereHash;
		Start ++;
		WhereHash +=2;
		for (Count = WhereHash; Count <=email.length; Count++)
		{
			TempAfter +=email.substring (Start, Count);
			Start++;
		}
		NewString = TempAfter +'@' + TempBefore;
		if (subject != null)
			NewString += '?subject=' + subject;
		parent.location = 'mailto:' + NewString;
	}
