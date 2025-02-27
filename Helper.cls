global without sharing class Helper {

	public static integer CharToAsc(String sChar){
		Integer nCode;
		nCode = -1;	// not ALPHA
		if(sChar =='A'){nCode = 65;}
		if(sChar =='B'){nCode = 66;}
		if(sChar =='C'){nCode = 67;}
		if(sChar =='D'){nCode = 68;}
		if(sChar =='E'){nCode = 69;}
		if(sChar =='F'){nCode = 70;}
		if(sChar =='G'){nCode = 71;}
		if(sChar =='H'){nCode = 72;}
		if(sChar =='I'){nCode = 73;}
		if(sChar =='J'){nCode = 74;}
		if(sChar =='K'){nCode = 75;}
		if(sChar =='L'){nCode = 76;}
		if(sChar =='M'){nCode = 77;}
		if(sChar =='N'){nCode = 78;}
		if(sChar =='O'){nCode = 79;}
		if(sChar =='P'){nCode = 80;}
		if(sChar =='Q'){nCode = 81;}
		if(sChar =='R'){nCode = 82;}
		if(sChar =='S'){nCode = 83;}
		if(sChar =='T'){nCode = 84;}
		if(sChar =='U'){nCode = 85;}
		if(sChar =='V'){nCode = 86;}
		if(sChar =='W'){nCode = 87;}
		if(sChar =='X'){nCode = 88;}
		if(sChar =='Y'){nCode = 89;}
		if(sChar =='Z'){nCode = 90;}
		
		return nCode;
		
	}
	
	public static integer CharToNumber(String sChar){
		
		return CharToAsc(sChar)-64; // A=65 
		
	}


	public static string ExcludeWords(String sCompanyName, List<String> sExcludeWords )
	{
		
		for(String sExcludeWord:sExcludeWords){
			sCompanyName = sCompanyName.replaceAll(sExcludeWord, '');
		}
		
		return sCompanyName;
	}


	public static string StipNonAlpha(String sCompanyName )
	{
		
		integer n;
		String cChar;
		integer nAsc;
		integer nLookup;
		String sCompanyCode = '';
		
		integer nStringLength = sCompanyName.length();
	
		for(n=0; n<=nStringLength-1 ; n++)
		{
			if (n<=nStringLength){
				cChar = sCompanyName.substring(n,n+1);
			}else{
					cChar = sCompanyName.substring(n);
			}
		
			nAsc = helper.CharToAsc(cChar);
			if (nAsc>0)// only asc chars
			{
				sCompanyCode = sCompanyCode+cChar;
				
			}
			
			
		}
	
		return sCompanyCode;
		
	}

	public static string Encode(String sCompanyName,integer offset )
	{
		
		String encode = 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRST';
		String sCompanyCode = '';
		integer n;
		String cChar;
		integer nAsc;
		integer nLookup;
		integer nStringLength = sCompanyName.length();

		for(n=0; n<=nStringLength-1 ; n++)
		{
			if (n<=nStringLength){
				cChar = sCompanyName.substring(n,n+1);
			}else{
					cChar = sCompanyName.substring(n);
			}
			
			
			
			system.debug('cChar is ' + n+ ' '+ cChar);
			
			if (n == 3 ||n == 4 ){
				nAsc = helper.CharToAsc(cChar);
				nLookup = nAsc -65;
				nLookup = nlookup+offset;
				if (nLookUp>26)
				{
					
					nLookup = nLookup -26;
				}
				system.debug('nLookup is ' + nLookup);
		
			sCompanyCode = sCompanyCode + encode.substring(nlookup,nlookup+1);
			}
			else
			{
			sCompanyCode = sCompanyCode +cChar;
			}
			
		}
		

		return sCompanyCode;
	}

///// NEW CODE /////////////////
/*	public static integer FindFirstNonAlpha(String sCompanyName )
	{
		
		integer n;
		String cChar; 
		integer nAsc;
		integer nLookup;
		String sCompanyCode = '';
		
		integer nStringLength = sCompanyName.length();
	
		for(n=0; n<=nStringLength-1 ; n++)
		{
			if (n<=nStringLength){
				cChar = sCompanyName.substring(n,n+1);
			}else{
					cChar = sCompanyName.substring(n);
			}
		
			nAsc = helper.CharToAsc(cChar);
			if (nAsc == -1)// only asc chars
			{
				return n;
				
			}
		}
	
		return -1; // non alpha found
	}
	
	
	
	public static string createfilter4(String sCompanyName){
		Integer nNonAlpha = FindFirstNonAlpha(sCompanyName);
		String sFilter = '';
		//sCompanyName = sCompanyName.substring(0,nNonAlpha); 
		//sCompanyName = sCompanyName.substring(0,4); 
		sCompanyName = sCompanyName.substring(0,3); 
		sFilter = '\''+sCompanyName +'%'+ '\'';
		return sFilter;
	}
*/	
	
	
	
	
	

	Public static String Clean(String sCompanyName,List<String> sExcludeWords){
		
			String sCleanComanyName;
			sCleanComanyName = sCompanyName;
			
			sCleanComanyName = sCleanComanyName.toUpperCase();
			//First Strip out Known words The Ltd etc
			sCleanComanyName = helper.ExcludeWords(sCleanComanyName,sExcludeWords);
			sCleanComanyName = sCleanComanyName.trim();
			sCleanComanyName = helper.StipNonAlpha(sCleanComanyName);
			//sCleanComanyName = sCleanComanyName +'ABCDEF';
			sCleanComanyName = sCleanComanyName +'UVXYZ';
			sCleanComanyName = sCleanComanyName.substring(0,5);// first 5 chars 
			system.debug('>>> Clean Name '+sCleanComanyName);
			return sCleanComanyName;
	}


	Private static String CreateFilter(String sCompanyName){
		String sFilter = '';
		sCompanyName = sCompanyName.substring(0,3); // just get the first 2 chars
		
		sFilter = '\''+sCompanyName +'%'+ '\'';
		return sFilter;
	}
	
/*	Private static String CreateFilter2(String sCompanyName){
		
		return ' a.client_code__c like' + CreateFilter(sCompanyName);
		
		
	}
	
	Private static String CreateFilter3(String sCompanyName){
		String sFilter = '';
		sFilter = '\''+sCompanyName + '\'';
		return sFilter;
	}
*/	
	
	Private static String CreateFilter5(String sCompanyName){
		String sFilter = '';
		
		system.debug('###### CreateFilter5 sCompanyName '+ sCompanyName);
		if (sCompanyName.length()>4 ){
			sCompanyName = sCompanyName.substring(0,4); // just get the first 2 chars
		}
		
		sCompanyName =string.escapeSingleQuotes(sCompanyName);
		
		
		sFilter = '\''+sCompanyName +'%'+ '\'';
		system.debug('###### CreateFilter5 sFilter '+ sFilter);
		return sFilter;
	}
	
	Private static String CreateFilter6(String sCompanyName){
		String sFilter = '';
		
		system.debug('###### CreateFilter6 sCompanyName '+ sCompanyName);
		if (sCompanyName.length()>5 ){
			sCompanyName = sCompanyName.substring(0,5); // just get the first 2 chars
		}
		sCompanyName =string.escapeSingleQuotes(sCompanyName);
		
		sFilter = '\''+sCompanyName +'%'+ '\'';
		system.debug('###### CreateFilter6 sFilter '+ sFilter);
		return sFilter;
	}
	

	
	
	 
	Public static string GetLastCodeForSecondaryUtil(String sCompanyName,ID Parentid){
		
		String sLastClientCode = '';
		
		String sFilter = CreateFilter(sCompanyName);
		String sParentid = '\''+parentid +'\'';
		
		//string sql       = 'Select a.id,a.Client_Code__c From Account a where a.parentid ='+sParentid +' and a.client_code__c like '+sFilter + ' order by a.ClientCodeDT__c desc ';
		string sql       = 'Select a.id,a.Client_Code__c From Account a where a.parentid ='+sParentid +' order by a.ClientCodeCount__c desc ';
		system.debug('>>>> sSql2 '+sql);
		Account[] acs;
		try{
			 acs = database.query(sql);
		}catch (Exception e) {
			
		}
		if (acs.size()>0){
			sLastClientCode = acs[0].Client_Code__c;
		}
		else{
			sLastClientCode ='';
		}
		
		return sLastClientCode;
		
	}
	
	Public static string GetLastCodeForSecondary(String sCompanyName, ID Accountid){
		
		String sLastClientCode = '';
		Account a = [Select a.Client_Code__c,a.name from account a where a.id =: accountid];
		//sLastClientCode = GetLastCodeForPrimary(a.name); // the case where there is only the parent initially
		String sLastClientCodePrimary = a.Client_Code__c;
		
		String sLastClientCodeSecondary = GetLastCodeForSecondaryUtil(sCompanyName,Accountid);
		system.debug(' >>>> GetLastCodeForSecondary '+sLastClientCodePrimary + ' ' +sLastClientCodeSecondary  );
		if (sLastClientCodeSecondary == null){
			sLastClientCodeSecondary ='';
		}
		if (sLastClientCodeSecondary.length()!= 0){
			sLastClientCode =sLastClientCodeSecondary;
			
		}else{
			sLastClientCode =  sLastClientCodePrimary;
			
		}
		system.debug('>>>>> GetLastCodeForSecondaryV2 '+sLastClientCode);
		return sLastClientCode;
		
	}
	
	
	Public static string GetLastCodeForPrimary(String sCompanyName,String sName){
		
		String sLastClientCode = '';
		string sql;
		String sFilter;
		sFilter = CreateFilter5(sName);
	
		
		sql       = 'Select a.id,a.Client_Code__c,a.ClientCodeDT__c From Account a where a.name  like '+sFilter + ' order by a.ClientCodeCount__c desc ';
		Account[] acs;
		
		try{
			 acs = database.query(sql);
		}catch (Exception e) {
			
		}
		
		system.debug('>>>> GetLastCodeForPrimary '+ acs);
		if (acs.size()>0){
			sLastClientCode = acs[0].Client_Code__c;
		}
		else{
			sLastClientCode ='';
		}
		
		return sLastClientCode;
		
	}
	
	
	 
	Public static double GetLastCountForPrimary(String sCompanyName,String sName){
		
		double dLastCount = 0;
		String sFilter;
	
		string sql;
	
		if(sName.contains('The')){
			sFilter = CreateFilter6(sName);
		}
		else{
			sFilter = CreateFilter5(sName);
		}
		
		
		sql       = 'Select a.ClientCodeCount__c From Account a where a.name  like '+sFilter + ' order by a.ClientCodeCount__c desc ';
		
		system.debug(sql);
		Account[] acs;
		
		try{
			 acs = database.query(sql);
		}catch (Exception e) {
			
		}
		 
		system.debug('>>>> GetLastCountForPrimary '+ acs);
		if (acs.size()>0){
			dLastCount = acs[0].ClientCodeCount__c;
		}
		else{
			dLastCount =0;
		}
		
		if (dLastCount == null){
			dLastCount =0;
		}
		return dLastCount;
		
	}
	
	Public static double IncrementLastCount(double lastCount){
		return ++lastCount;
	}
	
	
	
	
	Public static string GetFirstCodeForPrimary(String sCompanyName,String sName){
		
		String sLastClientCode = '';
		String sFilter;
		string sql;
		
		
		sFilter = CreateFilter5(sName);
		
		sql       = 'Select a.id,a.Client_Code__c,a.ClientCodeDT__c From Account a  where a.name  like '+sFilter + ' order by a.ClientCodeCount__c asc';
		system.debug('>>> Sql = '+sql);
		Account[] acs;
		try{
			 acs = database.query(sql);
		}catch (Exception e) {
			
		}
		
		system.debug('>>>> GetFirstCodeForPrimary '+ acs);
		
		if (acs != null){
			if (acs.size()>0){
				sLastClientCode = acs[0].Client_Code__c;
			}
			else{
				sLastClientCode ='';
			}
		}else{
			sLastClientCode ='';
		}
		
		return sLastClientCode;
		
	}
	
	
	
	
	private static String encodeFirstCodePrimary(String sCompanyName){
		String sEncode;
		sEncode = sCompanyName.substring(0, 4)+'A';
		return sEncode;
	}
	
	private static String encodeSecondCodePrimary(String sCompanyName){
		String sEncode;
		sEncode = sCompanyName.substring(0, 3)+'AA';
		return sEncode;
	}
	
	public static string encodeNextCodePrimary(String sCompanyName,Integer nSequence){
		String sEncode;
		if (sCompanyName.length() == 0){
			return '';
			
		}
		
		String encode = 'ZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRST';
		
		if (nSequence >= 1 && nSequence <=26){
			
			sEncode = sCompanyName.substring(0, 3)+ encode.substring(nSequence,nSequence+1)+'A';
			
		}else{
			Integer remainder = math.mod(nSequence, 26);
			Integer ans = nSequence /26;
			
			// condition when remainder = 0
			if (remainder == 0 ){
				ans = ans -1;
				
			}
			
			
			sEncode = sCompanyName.substring(0, 2)+ encode.substring(ans,ans+1) +  encode.substring(remainder,remainder+1) +'A';
			
		}
		


		return sEncode;
	}
	
	public static string encodeNextCodeSecondary(String sCompanyName,Integer nSequence){
		String sEncode;
		
		if (sCompanyName.length() == 0){
			return 'ERROR';
		}
		String encode = 'ZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRST';
		
		system.debug('>>>> nSequence '+nSequence);
		if (nSequence >= 1 && nSequence <=26){
			
			sEncode = sCompanyName.substring(0, 4)+ encode.substring(nSequence,nSequence+1);
			
		}else{
			Integer remainder = math.mod(nSequence, 26);
			Integer ans = nSequence /26;
			
			// condition when remainder = 0
			if (remainder == 0 ){
				ans = ans -1;
				
			}
			
			system.debug('>>>> ans remainder '+ans +' '+remainder );
			sEncode = sCompanyName.substring(0, 3)+ encode.substring(ans,ans+1) +  encode.substring(remainder,remainder+1);
		}
		return sEncode;
	}
	
	
	
	
	public static Integer CalcSequence(String sSequence){
		Integer nCode;
		
		if(sSequence.length() == 1){
			
			nCode = CharToNumber(sSequence);
			
		}else {
			String sFirstChar = sSequence.substring(0, 1);
			String sSecondChar = sSequence.substring(1);
			
			nCode = CharToNumber(sFirstChar)*26 + CharToNumber(sSecondChar);
			
		}
		
		
		return nCode;
		
		
	}
	
	public static string EncodeForPrimaryV2(string sFirstCode,String sLastCode,String sCompanyName,String OrginalName){
		
		Integer nSequence=0;
		List<String> sCodeUsed = CodesAlreadyUsed(sCompanyName);
		system.debug('###### sCodeUsed '+sCodeUsed);
		double nLastCount = helper.GetLastCountForPrimary(sCompanyName,OrginalName);
		String sEncode;
		if (nLastCount == 0 ){
			
			sEncode = encodeFirstCodePrimary(sCompanyName);	
		}else if (nLastCount == 1){
			sEncode = encodeSecondCodePrimary(sCompanyName);
			
		}else{
			
		String sCompChar3 =sCompanyName.substring(2,3);
				String sCompChar4 =sCompanyName.substring(3,4);
				String sCodeChar3 =sLastCode.substring(2,3);
				String sCodeChar4 =sLastCode.substring(3,4);
				String sSequence; 
				
				system.debug ('#### CHARS '+sCompChar3+' '+sCompChar4+ ' '+sCodeChar3+ ' '+sCodeChar4);
				
				if (sCompChar3.equals(sCodeChar3)){
					sSequence = sCodeChar4;
				}else{
					
					sSequence = sCodeChar3+sCodeChar4;
				}
				
				
				nSequence = CalcSequence(sSequence);
				System.debug('#### EncodeForPrimary Sequence '+sSequence +' '+ string.valueof(nSequence) );
				
				nSequence++;
				sEncode =encodeNextCodePrimary(sCompanyName,nSequence);
				
				//check to see if this is already used
				//if (sFirstCode.equals(sEncode)){
				//	nSequence++;
				//	sEncode =encodeNextCodePrimary(sCompanyName,nSequence);
				//}
				
				
			 
		}
		
	// check to see if this code is already used
	 Boolean bFound; 
	 bFound = isCodeUsed(sCodeUsed,sEncode);
	 if(sCodeUsed.size()>0 && bFound == True ){
	 	

		 do{ 
		 	
		 	
		 	nSequence++;
		 	sEncode =encodeNextCodePrimary(sCompanyName,nSequence);
		 	bFound = isCodeUsed(sCodeUsed,sEncode);
		 } while(bFound);		
	}	
		
	
	system.debug('>>> EncodeForPrimary sEncode is'+ sEncode);
	return sEncode;
	
		
		
	}
	
	
	
	
	

	public static string EncodeForSecondary(String sFirstCode,String sLastCode,String sCompanyName){
		
			system.debug('>>>> EncodeForSecondary '+sFirstCode+ ' - '+ sLastCode + ' - ' + sCompanyName);
				
				
				//List<String> sCodeUsed = CodesAlreadyUsed(sCompanyName);
				List<String> sCodeUsed = CodesAlreadyUsed(sLastCode);
				system.debug('>>>> EncodeForSecondary sCodeUsed '+sCodeUsed);
				Integer nSequence =0;
				String sEncode;
				String sCompChar4 =sCompanyName.substring(3,4);
				String sCompChar5 =sCompanyName.substring(4);
				
				if (sLastCode.length() !=5 ){
					return 'ERROR';
				}
				
				String sCodeChar4 =sLastCode.substring(3,4);
				String sCodeChar5 =sLastCode.substring(4);
				
				String sSequence; 
				 
				if (sCompChar4.equals(sCodeChar4)){
					sSequence = sCodeChar5;
				}else{
					
					sSequence = sCodeChar4+sCodeChar5;
				}
			 	 
				nSequence = CalcSequence(sSequence);
				nSequence++;
				sEncode =encodeNextCodeSecondary(sLastCode,nSequence);
				system.debug('>>> EncodeForSecondary sEncode is 1 '+ sEncode);
				// check to see if it used already
				
				 Boolean bFound; 
				 bFound = isCodeUsed(sCodeUsed,sEncode);
				 if(sCodeUsed.size()>0 && bFound == True ){
					 do{ 
					 	nSequence++;
					 	sEncode =encodeNextCodeSecondary(sLastCode,nSequence);
					 	bFound = isCodeUsed(sCodeUsed,sEncode);
					 	system.debug('>>> EncodeForSecondary sEncode is 2 '+ sEncode);
					 } while(bFound);		
				}	
				
				system.debug('>>> EncodeForSecondary sEncode RESULT is'+ sEncode);
				return sEncode;
		
	}
	
	

	public static Boolean isCodeUsed(List<string> codesUsed,String sNewCode){
		Boolean bfound = false;
		for(String s:codesUsed){
			if (s.equals(sNewCode)){
				bFound = true;
			}
		}
			
		return bfound;	
		
	}



	public static List<string> CodesAlreadyUsed(String sName){
		string sql;
		string sFilter;
		List<String> my_list = new List<String>();
		
		
		sName = sName.substring(0,2); // just get the first 2 chars
		sFilter = '\''+sName +'%'+ '\'';
		
		sFilter = CreateFilter5(sName);
		sql       = 'Select a.id,a.Client_Code__c,a.ClientCodeDT__c From Account a  where a.Client_Code__c like '+sFilter + ' order by a.ClientCodeCount__c asc';
		
		
		system.debug('>>> Sql = '+sql);
		Account[] acs;
		try{
			 acs = database.query(sql);
		}catch (Exception e) {
			
		}
		
		
		for(Account a: acs){
			my_list.add(a.Client_Code__c);		
		}
		return my_list;
		
		
		
	}

	




}