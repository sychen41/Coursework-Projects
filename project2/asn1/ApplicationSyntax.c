/*
 * Generated by asn1c-0.9.21 (http://lionet.info/asn1c)
 * From ASN.1 module "MyTest"
 * 	found in "../MyTest.asn1"
 * 	`asn1c -fnative-types`
 */

#include <asn_internal.h>

#include "ApplicationSyntax.h"

static asn_TYPE_member_t asn_MBR_ApplicationSyntax_1[] = {
	{ ATF_NOFLAGS, 0, offsetof(struct ApplicationSyntax, choice.ipAddress_value),
		(ASN_TAG_CLASS_APPLICATION | (0 << 2)),
		0,
		&asn_DEF_IpAddress,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"ipAddress-value"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct ApplicationSyntax, choice.counter_value),
		(ASN_TAG_CLASS_APPLICATION | (1 << 2)),
		0,
		&asn_DEF_Counter32,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"counter-value"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct ApplicationSyntax, choice.timeticks_value),
		(ASN_TAG_CLASS_APPLICATION | (3 << 2)),
		0,
		&asn_DEF_TimeTicks,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"timeticks-value"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct ApplicationSyntax, choice.arbitrary_value),
		(ASN_TAG_CLASS_APPLICATION | (4 << 2)),
		0,
		&asn_DEF_Opaque,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"arbitrary-value"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct ApplicationSyntax, choice.unsigned_integer_value),
		(ASN_TAG_CLASS_APPLICATION | (2 << 2)),
		0,
		&asn_DEF_Unsigned32,
		0,	/* Defer constraints checking to the member type */
		0,	/* PER is not compiled, use -gen-PER */
		0,
		"unsigned-integer-value"
		},
};
static asn_TYPE_tag2member_t asn_MAP_ApplicationSyntax_tag2el_1[] = {
    { (ASN_TAG_CLASS_APPLICATION | (0 << 2)), 0, 0, 0 }, /* ipAddress-value at 41 */
    { (ASN_TAG_CLASS_APPLICATION | (1 << 2)), 1, 0, 0 }, /* counter-value at 42 */
    { (ASN_TAG_CLASS_APPLICATION | (2 << 2)), 4, 0, 0 }, /* unsigned-integer-value at 45 */
    { (ASN_TAG_CLASS_APPLICATION | (3 << 2)), 2, 0, 0 }, /* timeticks-value at 43 */
    { (ASN_TAG_CLASS_APPLICATION | (4 << 2)), 3, 0, 0 } /* arbitrary-value at 44 */
};
static asn_CHOICE_specifics_t asn_SPC_ApplicationSyntax_specs_1 = {
	sizeof(struct ApplicationSyntax),
	offsetof(struct ApplicationSyntax, _asn_ctx),
	offsetof(struct ApplicationSyntax, present),
	sizeof(((struct ApplicationSyntax *)0)->present),
	asn_MAP_ApplicationSyntax_tag2el_1,
	5,	/* Count of tags in the map */
	0,
	-1	/* Extensions start */
};
asn_TYPE_descriptor_t asn_DEF_ApplicationSyntax = {
	"ApplicationSyntax",
	"ApplicationSyntax",
	CHOICE_free,
	CHOICE_print,
	CHOICE_constraint,
	CHOICE_decode_ber,
	CHOICE_encode_der,
	CHOICE_decode_xer,
	CHOICE_encode_xer,
	0, 0,	/* No PER support, use "-gen-PER" to enable */
	CHOICE_outmost_tag,
	0,	/* No effective tags (pointer) */
	0,	/* No effective tags (count) */
	0,	/* No tags (pointer) */
	0,	/* No tags (count) */
	0,	/* No PER visible constraints */
	asn_MBR_ApplicationSyntax_1,
	5,	/* Elements count */
	&asn_SPC_ApplicationSyntax_specs_1	/* Additional specs */
};
