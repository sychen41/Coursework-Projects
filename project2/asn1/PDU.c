/*
 * Generated by asn1c-0.9.21 (http://lionet.info/asn1c)
 * From ASN.1 module "MyTest"
 * 	found in "../MyTest.asn1"
 * 	`asn1c -fnative-types`
 */

#include <asn_internal.h>

#include "PDU.h"

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
memb_error_index_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
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

static asn_TYPE_member_t asn_MBR_PDU_1[] = {
	{ ATF_NOFLAGS, 0, offsetof(struct PDU, request_id),
		(ASN_TAG_CLASS_UNIVERSAL | (2 << 2)),
		0,
		&asn_DEF_NativeInteger,
		memb_request_id_constraint_1,
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"request-id"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct PDU, error_status),
		(ASN_TAG_CLASS_UNIVERSAL | (2 << 2)),
		0,
		&asn_DEF_NativeInteger,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"error-status"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct PDU, error_index),
		(ASN_TAG_CLASS_UNIVERSAL | (2 << 2)),
		0,
		&asn_DEF_NativeInteger,
		memb_error_index_constraint_1,
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"error-index"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct PDU, variable_bindings),
		(ASN_TAG_CLASS_UNIVERSAL | (16 << 2)),
		0,
		&asn_DEF_VarBindList,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"variable-bindings"
		},
};
static ber_tlv_tag_t asn_DEF_PDU_tags_1[] = {
	(ASN_TAG_CLASS_UNIVERSAL | (16 << 2))
};
static asn_TYPE_tag2member_t asn_MAP_PDU_tag2el_1[] = {
    { (ASN_TAG_CLASS_UNIVERSAL | (2 << 2)), 0, 0, 2 }, /* request-id at 99 */
    { (ASN_TAG_CLASS_UNIVERSAL | (2 << 2)), 1, -1, 1 }, /* error-status at 103 */
    { (ASN_TAG_CLASS_UNIVERSAL | (2 << 2)), 2, -2, 0 }, /* error-index at 125 */
    { (ASN_TAG_CLASS_UNIVERSAL | (16 << 2)), 3, 0, 0 } /* variable-bindings at 129 */
};
static asn_SEQUENCE_specifics_t asn_SPC_PDU_specs_1 = {
	sizeof(struct PDU),
	offsetof(struct PDU, _asn_ctx),
	asn_MAP_PDU_tag2el_1,
	4,	/* Count of tags in the map */
	0, 0, 0,	/* Optional elements (not needed) */
	-1,	/* Start extensions */
	-1	/* Stop extensions */
};
asn_TYPE_descriptor_t asn_DEF_PDU = {
	"PDU",
	"PDU",
	SEQUENCE_free,
	SEQUENCE_print,
	SEQUENCE_constraint,
	SEQUENCE_decode_ber,
	SEQUENCE_encode_der,
	SEQUENCE_decode_xer,
	SEQUENCE_encode_xer,
	0, 0,	/* No PER support, use "-gen-PER" to enable */
	0,	/* Use generic outmost tag fetcher */
	asn_DEF_PDU_tags_1,
	sizeof(asn_DEF_PDU_tags_1)
		/sizeof(asn_DEF_PDU_tags_1[0]), /* 1 */
	asn_DEF_PDU_tags_1,	/* Same as above */
	sizeof(asn_DEF_PDU_tags_1)
		/sizeof(asn_DEF_PDU_tags_1[0]), /* 1 */
	0,	/* No PER visible constraints */
	asn_MBR_PDU_1,
	4,	/* Elements count */
	&asn_SPC_PDU_specs_1	/* Additional specs */
};

