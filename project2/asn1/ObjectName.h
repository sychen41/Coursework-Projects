/*
 * Generated by asn1c-0.9.21 (http://lionet.info/asn1c)
 * From ASN.1 module "MyTest"
 * 	found in "../MyTest.asn1"
 * 	`asn1c -fnative-types`
 */

#ifndef	_ObjectName_H_
#define	_ObjectName_H_


#include <asn_application.h>

/* Including external dependencies */
#include <OBJECT_IDENTIFIER.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ObjectName */
typedef OBJECT_IDENTIFIER_t	 ObjectName_t;

/* Implementation */
extern asn_TYPE_descriptor_t asn_DEF_ObjectName;
asn_struct_free_f ObjectName_free;
asn_struct_print_f ObjectName_print;
asn_constr_check_f ObjectName_constraint;
ber_type_decoder_f ObjectName_decode_ber;
der_type_encoder_f ObjectName_encode_der;
xer_type_decoder_f ObjectName_decode_xer;
xer_type_encoder_f ObjectName_encode_xer;

#ifdef __cplusplus
}
#endif

#endif	/* _ObjectName_H_ */
