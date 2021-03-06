/*
 * Generated by asn1c-0.9.21 (http://lionet.info/asn1c)
 * From ASN.1 module "MyTest"
 * 	found in "../MyTest.asn1"
 * 	`asn1c -fnative-types`
 */

#include <asn_internal.h>

#include "BulkPDU.h"

static int
memb_request_id_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	long value;
	
	if(!sptr) {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: value not given (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
	
	value = *(const long *)sptr;
	
	if((value >= -214783648 && value <= 214783647)) {
		/* Constraint check succeeded */
		return 0;
	} else {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: constraint failed (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
}

static int
memb_non_repeaters_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	long value;
	
	if(!sptr) {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: value not given (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
	
	value = *(const long *)sptr;
	
	if((value >= 0 && value <= 2147483647)) {
		/* Constraint check succeeded */
		return 0;
	} else {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: constraint failed (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
}

static int
memb_max_repetitions_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	long value;
	
	if(!sptr) {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: value not given (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
	
	value = *(const long *)sptr;
	
	if((value >= 0 && value <= 2147483647)) {
		/* Constraint check succeeded */
		return 0;
	} else {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: constraint failed (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
}

static asn_TYPE_member_t asn_MBR_BulkPDU_1[] = {
	{ ATF_NOFLAGS, 0, offsetof(struct BulkPDU, request_id),
		(ASN_TAG_CLASS_UNIVERSAL | (2 << 2)),
		0,
		&asn_DEF_NativeInteger,
		memb_request_id_constraint_1,
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"request-id"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct BulkPDU, non_repeaters),
		(ASN_TAG_CLASS_UNIVERSAL | (2 << 2)),
		0,
		&asn_DEF_NativeInteger,
		memb_non_repeaters_constraint_1,
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"non-repeaters"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct BulkPDU, max_repetitions),
		(ASN_TAG_CLASS_UNIVERSAL | (2 << 2)),
		0,
		&asn_DEF_NativeInteger,
		memb_max_repetitions_constraint_1,
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"max-repetitions"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct BulkPDU, variable_bindings),
		(ASN_TAG_CLASS_UNIVERSAL | (16 << 2)),
		0,
		&asn_DEF_VarBindList,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"variable-bindings"
		},
};
static ber_tlv_tag_t asn_DEF_BulkPDU_tags_1[] = {
	(ASN_TAG_CLASS_UNIVERSAL | (16 << 2))
};
static asn_TYPE_tag2member_t asn_MAP_BulkPDU_tag2el_1[] = {
    { (ASN_TAG_CLASS_UNIVERSAL | (2 << 2)), 0, 0, 2 }, /* request-id at 133 */
    { (ASN_TAG_CLASS_UNIVERSAL | (2 << 2)), 1, -1, 1 }, /* non-repeaters at 134 */
    { (ASN_TAG_CLASS_UNIVERSAL | (2 << 2)), 2, -2, 0 }, /* max-repetitions at 135 */
    { (ASN_TAG_CLASS_UNIVERSAL | (16 << 2)), 3, 0, 0 } /* variable-bindings at 139 */
};
static asn_SEQUENCE_specifics_t asn_SPC_BulkPDU_specs_1 = {
	sizeof(struct BulkPDU),
	offsetof(struct BulkPDU, _asn_ctx),
	asn_MAP_BulkPDU_tag2el_1,
	4,	/* Count of tags in the map */
	0, 0, 0,	/* Optional elements (not needed) */
	-1,	/* Start extensions */
	-1	/* Stop extensions */
};
asn_TYPE_descriptor_t asn_DEF_BulkPDU = {
	"BulkPDU",
	"BulkPDU",
	SEQUENCE_free,
	SEQUENCE_print,
	SEQUENCE_constraint,
	SEQUENCE_decode_ber,
	SEQUENCE_encode_der,
	SEQUENCE_decode_xer,
	SEQUENCE_encode_xer,
	0, 0,	/* No PER support, use "-gen-PER" to enable */
	0,	/* Use generic outmost tag fetcher */
	asn_DEF_BulkPDU_tags_1,
	sizeof(asn_DEF_BulkPDU_tags_1)
		/sizeof(asn_DEF_BulkPDU_tags_1[0]), /* 1 */
	asn_DEF_BulkPDU_tags_1,	/* Same as above */
	sizeof(asn_DEF_BulkPDU_tags_1)
		/sizeof(asn_DEF_BulkPDU_tags_1[0]), /* 1 */
	0,	/* No PER visible constraints */
	asn_MBR_BulkPDU_1,
	4,	/* Elements count */
	&asn_SPC_BulkPDU_specs_1	/* Additional specs */
};

