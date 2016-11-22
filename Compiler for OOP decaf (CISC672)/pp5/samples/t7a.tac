_Animal.InitAnimal:
	BeginFunc 0 ;
	*(this + 4) = h ;
	*(this + 8) = mom ;
	EndFunc ;
_Animal.GetHeight:
	BeginFunc 4 ;
	_tmp0 = *(this + 4) ;
	Return _tmp0 ;
	EndFunc ;
_Animal.GetMom:
	BeginFunc 4 ;
	_tmp1 = *(this + 8) ;
	Return _tmp1 ;
	EndFunc ;
VTable Animal =
	_Animal.InitAnimal,
	_Animal.GetHeight,
	_Animal.GetMom,
; 
_Cow.InitCow:
	BeginFunc 8 ;
	*(this + 12) = spot ;
	_tmp2 = *(this) ;
	_tmp3 = *(_tmp2) ;
	PushParam m ;
	PushParam h ;
	PushParam this ;
	ACall _tmp3 ;
	PopParams 12 ;
	EndFunc ;
_Cow.IsSpottedCow:
	BeginFunc 4 ;
	_tmp4 = *(this + 12) ;
	Return _tmp4 ;
	EndFunc ;
VTable Cow =
	_Animal.InitAnimal,
	_Animal.GetHeight,
	_Animal.GetMom,
	_Cow.InitCow,
	_Cow.IsSpottedCow,
; 
main:
	BeginFunc 84 ;
	_tmp5 = 16 ;
	PushParam _tmp5 ;
	_tmp6 = LCall _Alloc ;
	PopParams 4 ;
	_tmp7 = Cow ;
	*(_tmp6) = _tmp7 ;
	betsy = _tmp6 ;
	_tmp8 = 5 ;
	_tmp9 = 0 ;
	_tmp10 = 1 ;
	_tmp11 = *(betsy) ;
	_tmp12 = *(_tmp11 + 12) ;
	PushParam _tmp10 ;
	PushParam _tmp9 ;
	PushParam _tmp8 ;
	PushParam betsy ;
	ACall _tmp12 ;
	PopParams 16 ;
	b = betsy ;
	_tmp13 = *(b) ;
	_tmp14 = *(_tmp13 + 8) ;
	PushParam b ;
	_tmp15 = ACall _tmp14 ;
	PopParams 4 ;
	_tmp16 = "spots: " ;
	PushParam _tmp16 ;
	LCall _PrintString ;
	PopParams 4 ;
	_tmp17 = *(betsy) ;
	_tmp18 = *(_tmp17 + 16) ;
	PushParam betsy ;
	_tmp19 = ACall _tmp18 ;
	PopParams 4 ;
	PushParam _tmp19 ;
	LCall _PrintBool ;
	PopParams 4 ;
	_tmp20 = "    height: " ;
	PushParam _tmp20 ;
	LCall _PrintString ;
	PopParams 4 ;
	_tmp21 = *(b) ;
	_tmp22 = *(_tmp21 + 4) ;
	PushParam b ;
	_tmp23 = ACall _tmp22 ;
	PopParams 4 ;
	PushParam _tmp23 ;
	LCall _PrintInt ;
	PopParams 4 ;
	EndFunc ;
