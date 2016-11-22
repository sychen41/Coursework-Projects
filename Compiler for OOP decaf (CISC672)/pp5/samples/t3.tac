main:
	BeginFunc 40 ;
	_tmp0 = 12 ;
	PushParam _tmp0 ;
	_tmp1 = LCall _Alloc ;
	PopParams 4 ;
	_tmp2 = Cow ;
	*(_tmp1) = _tmp2 ;
	betsy = _tmp1 ;
	_tmp3 = 100 ;
	_tmp4 = 122 ;
	_tmp5 = *(betsy) ;
	_tmp6 = *(_tmp5) ;
	PushParam _tmp4 ;
	PushParam _tmp3 ;
	PushParam betsy ;
	ACall _tmp6 ;
	PopParams 12 ;
	_tmp7 = *(betsy) ;
	_tmp8 = *(_tmp7 + 4) ;
	PushParam betsy ;
	ACall _tmp8 ;
	PopParams 4 ;
	EndFunc ;
_Cow.Init:
	BeginFunc 0 ;
	*(this + 8) = w ;
	*(this + 4) = h ;
	EndFunc ;
_Cow.Moo:
	BeginFunc 16 ;
	_tmp9 = *(this + 4) ;
	PushParam _tmp9 ;
	LCall _PrintInt ;
	PopParams 4 ;
	_tmp10 = " " ;
	PushParam _tmp10 ;
	LCall _PrintString ;
	PopParams 4 ;
	_tmp11 = *(this + 8) ;
	PushParam _tmp11 ;
	LCall _PrintInt ;
	PopParams 4 ;
	_tmp12 = "\n" ;
	PushParam _tmp12 ;
	LCall _PrintString ;
	PopParams 4 ;
	EndFunc ;
VTable Cow =
	_Cow.Init,
	_Cow.Moo,
; 
