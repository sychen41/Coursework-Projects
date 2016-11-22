/*
 * Generated by asn1c-0.9.21 (http://lionet.info/asn1c)
 * From ASN.1 module "MyTest"
 * 	found in "../MyTest.asn1"
 * 	`asn1c -fnative-types`
 */

#include <asn_internal.h>

#include "GetBulkRequest-PDU.h"

int
GetBulkRequest_PDU_constraint(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	/* Replace with underlying type checker */
	td->check_constraints = asn_DEF_BulkPDU.check_constraints;
	return td->check_constraints(td, sptr, ctfailcb, app_key);
}

/*
 * This type is implemented using BulkPDU,
 * so here we adjust the DEF accordingly.
 */
static void
GetBulkRequest_PDU_1_inherit_TYPE_descriptor(asn_TYPE_descriptor_t *td) {
	td->free_struct    = asn_DEF_BulkPDU.free_struct;
	td->print_struct   = asn_DEF_BulkPDU.print_struct;
	td->ber_decoder    = asn_DEF_BulkPDU.ber_decoder;
	td->der_encoder    = asn_DEF_BulkPDU.der_encoder;
	td->xer_decoder    = asn_DEF_BulkPDU.xer_decoder;
	td->xer_encoder    = asn_DEF_BulkPDU.xer_encoder;
	td->uper_decoder   = asn_DEF_BulkPDU.uper_decoder;
	td->uper_encoder   = asn_DEF_BulkPDU.uper_encoder;
	if(!td->per_constraints)
		td->per_constraints = asn_DEF_BulkPDU.per_constraints;
	td->elements       = asn_DEF_BulkPDU.elements;
	td->elements_count = asn_DEF_BulkPDU.elements_count;
	td->specifics      = asn_DEF_BulkPDU.specifics;
}

void
GetBulkRequest_PDU_free(asn_TYPE_descriptor_t *td,
		void *struct_ptr, int contents_only) {
	GetBulkRequest_PDU_1_inherit_TYPE_descriptor(td);
	td->free_struct(td, struct_ptr, contents_only);
}

int
GetBulkRequest_PDU_print(asn_TYPE_descriptor_t *td, const void *struct_ptr,
		int ilevel, asn_app_consume_bytes_f *cb, void *app_key) {
	GetBulkRequest_PDU_1_inherit_TYPE_descriptor(td);
	return td->print_struct(td, struct_ptr, ilevel, cb, app_key);
}

asn_dec_rval_t
GetBulkRequest_PDU_decode_ber(asn_codec_ctx_t *opt_codec_ctx, asn_TYPE_descriptor_t *td,
		void **structure, const void *bufptr, size_t size, int tag_mode) {
	GetBulkRequest_PDU_1_inherit_TYPE_descriptor(td);
	return td->ber_decoder(opt_codec_ctx, td, structure, bufptr, size, tag_mode);
}

asn_enc_rval_t
GetBulkRequest_PDU_encode_der(asn_TYPE_descriptor_t *td,
		void *structure, int tag_mode, ber_tlv_tag_t tag,
		asn_app_consume_bytes_f *cb, void *app_key) {
	GetBulkRequest_PDU_1_inherit_TYPE_descriptor(td);
	return td->der_encoder(td, structure, tag_mode, tag, cb, app_key);
}

asn_dec_rval_t
GetBulkRequest_PDU_decode_xer(asn_codec_ctx_t *opt_codec_ctx, asn_TYPE_descriptor_t *td,
		void **structure, const char *opt_mname, const void *bufptr, size_t size) {
	GetBulkRequest_PDU_1_inherit_TYPE_descriptor(td);
	return td->xer_decoder(opt_codec_ctx, td, structure, opt_mname, bufptr, size);
}

asn_enc_rval_t
GetBulkRequest_PDU_encode_xer(asn_TYPE_descriptor_t *td, void *structure,
		int ilevel, enum xer_encoder_flags_e flags,
		asn_app_consume_bytes_f *cb, void *app_key) {
	GetBulkRequest_PDU_1_inherit_TYPE_descriptor(td);
	return td->xer_encoder(td, structure, ilevel, flags, cb, app_key);
}

static ber_tlv_tag_t asn_DEF_GetBulkRequest_PDU_tags_1[] = {
	(ASN_TAG_CLASS_CONTEXT | (5 << 2)),
	(ASN_TAG_CLASS_UNIVERSAL | (16 << 2))
};
asn_TYPE_descriptor_t asn_DEF_GetBulkRequest_PDU = {
	"GetBulkRequest-PDU",
	"GetBulkRequest-PDU",
	GetBulkRequest_PDU_free,
	GetBulkRequest_PDU_print,
	GetBulkRequest_PDU_constraint,
	GetBulkRequest_PDU_decode_ber,
	GetBulkRequest_PDU_encode_der,
	GetBulkRequest_PDU_decode_xer,
	GetBulkRequest_PDU_encode_xer,
	0, 0,	/* No PER support, use "-gen-PER" to enable */
	0,	/* Use generic outmost tag fetcher */
	asn_DEF_GetBulkRequest_PDU_tags_1,
	sizeof(asn_DEF_GetBulkRequest_PDU_tags_1)
		/sizeof(asn_DEF_GetBulkRequest_PDU_tags_1[0]) - 1, /* 1 */
	asn_DEF_GetBulkRequest_PDU_tags_1,	/* Same as above */
	sizeof(asn_DEF_GetBulkRequest_PDU_tags_1)
		/sizeof(asn_DEF_GetBulkRequest_PDU_tags_1[0]), /* 2 */
	0,	/* No PER visible constraints */
	0, 0,	/* Defined elsewhere */
	0	/* No specifics */
};
