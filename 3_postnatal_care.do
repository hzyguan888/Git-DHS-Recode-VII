
******************************
***Postnatal Care************* 
****************************** 


    *c_pnc_skill: m52 m64 m68 m72 m76 by var label text
	*c_pnc_any : mother OR child receive PNC in first six weeks by skilled health worker	
	*c_pnc_eff: mother AND child in first 24h by skilled health worker

	if ~inlist(name,"Afghanistan2015","Myanmar2015") {
	foreach var of varlist m64 m68 m72 m76{
		local s=substr("`var'",-2,.)
		local t=`s'-2
		gen `var'_skill =0 if !inlist(m`t',0,1)
		
		decode `var', gen(`var'_lab)
		replace `var'_lab = lower(`var'_lab )
		replace  `var'_skill= 1 if ///
		(regexm(`var'_lab,"doctor|nurse|midwife|mifwife|aide soignante|assistante accoucheuse|clinical officer|mch aide|trained|auxiliary birth attendant|physician assistant|professional|ferdsher|feldshare|skilled|community health care provider|birth attendant|hospital/health center worker|hew|auxiliary|icds|feldsher|mch|vhw|village health team|health personnel|gynecolog(ist|y)|obstetrician|internist|pediatrician|family welfare visitor|medical assistant|health assistant|matron|general practitioner|health officer|extension|ob-gy") ///
		& (regexm(`var'_lab,"trained") | !regexm(`var'_lab,"na^|-na|traditional birth attendant|untrained|unquallified|empirical midwife|box|other|community"))) 

		replace `var'_skill = . if mi(`var') | `var' == 99
		}

	/* consider as skilled if contain words in the first group but don't contain any words in the second group */
		
	gen c_pnc_any = .
		replace c_pnc_any = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_any = 1 if (m63 <= 306 & m64_skill == 1) | (m67 <= 306 & m68_skill == 1) | (m71 <= 306 & m72_skill == 1) | (m75 <= 306 & m76_skill == 1)
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	
	
	gen c_pnc_eff = .
		
		replace c_pnc_eff = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_eff = 1 if (((inrange(m63,100,124) | m63 == 201 ) & m64_skill == 1) | ((inrange(m67,100,124) | m67 == 201) & m68_skill == 1)) & (((inrange(m71,100,124) | m71 == 201) & m72_skill == 1) | ((inrange(m75,100,124) | m75 == 201) & m76_skill == 1))
		replace c_pnc_eff = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
	if inlist(name,"Afghanistan2015") {
		gen c_pnc_any = 0 if m70 != . | m50 != . 
        replace c_pnc_any = 1 if (m71 <= 306 & inrange(m72,11,13) ) | (m51 <= 306 & inrange(m52,11,13) )
		replace c_pnc_any = . if inlist(m71,199,299,399,998)| inlist(m51,998)| m72 == 8 | m52 == 8
		
		gen c_pnc_eff = 0 if m70 != . | m50 != . 
		replace c_pnc_eff = 1 if (((inrange(m71,100,124) | m71 == 201 ) & inrange(m72,11,13)) & ((inrange(m51,100,124) | m51 == 201) & inrange(m52,11,13))) 
		replace c_pnc_eff = . if inlist(m71,199,299,399,998)| inlist(m51,998)| m72 == 8 | m52 == 8
	}
	
	if inlist(name,"Myanmar2015") {
		gen c_pnc_any = 0 if m62 != . | m66 != . | m70 != . 
		replace c_pnc_any = 1 if (m63 <= 306 & inrange(m64,11,13)) | (m67 <= 306 & inrange(m68,11,13)) | (m71 <= 306 & inrange(m72,11,13))
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 
		
		gen c_pnc_eff = 0 if m62 != . | m66 != . | m70 != . 
		replace c_pnc_eff = 1 if (((inrange(m63,100,124) | m63 == 201 ) & inrange(m64,11,13)) | ((inrange(m67,100,124) | m67 == 201) & inrange(m68,11,13))) & (((inrange(m71,100,124) | m71 == 201) & inrange(m72,11,13)))
		replace c_pnc_eff = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
		
	}  
	
	*c_pnc_eff_q: mother AND child in first 24h by skilled health worker among those with any PNC
	gen c_pnc_eff_q = c_pnc_eff if c_pnc_any == 1
	
	
	*c_pnc_eff2: mother AND child in first 24h by skilled health worker and cord check, temperature check and breastfeeding counselling within first two days
	
	egen check = rowtotal(m78a m78b m78d),mi
	gen c_pnc_eff2 = c_pnc_eff
	replace c_pnc_eff2 = 0 if check != 3
	replace c_pnc_eff2 = . if c_pnc_eff == . | m78a == 8 | m78b == 8 | m78d == 8
	
	
	
    *c_pnc_eff2_q: mother AND child in first 24h weeks by skilled health worker and cord check, temperature check and breastfeeding counselling within first two days among those with any PNC
	
	gen c_pnc_eff2_q = c_pnc_eff2 if c_pnc_any ==1
		
