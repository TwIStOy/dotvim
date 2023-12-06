require("ffi").cdef([[

// cairo.h from cairo 1.12.3 (native extensions in separate files)

// NOTE: enum types are replaced with cairo_enum_t which is an int32_t so that
// functions returning an enum will not create an enum object on the heap!

typedef int       int32_t;
typedef long long int64_t;

typedef int32_t cairo_enum_t;

int cairo_version (void);

const char* cairo_version_string (void);

typedef int cairo_bool_t;

typedef struct _cairo cairo_t;

typedef struct _cairo_surface cairo_surface_t;

typedef struct _cairo_device cairo_device_t;

typedef struct _cairo_matrix {
	double xx; double yx;
	double xy; double yy;
	double x0; double y0;
} cairo_matrix_t;

typedef struct _cairo_pattern cairo_pattern_t;

typedef void (*cairo_destroy_func_t) (void *data);

typedef struct _cairo_user_data_key {
	int unused;
} cairo_user_data_key_t;

typedef enum _cairo_status {
	CAIRO_STATUS_SUCCESS = 0,
	CAIRO_STATUS_NO_MEMORY,
	CAIRO_STATUS_INVALID_RESTORE,
	CAIRO_STATUS_INVALID_POP_GROUP,
	CAIRO_STATUS_NO_CURRENT_POINT,
	CAIRO_STATUS_INVALID_MATRIX,
	CAIRO_STATUS_INVALID_STATUS,
	CAIRO_STATUS_NULL_POINTER,
	CAIRO_STATUS_INVALID_STRING,
	CAIRO_STATUS_INVALID_PATH_DATA,
	CAIRO_STATUS_READ_ERROR,
	CAIRO_STATUS_WRITE_ERROR,
	CAIRO_STATUS_SURFACE_FINISHED,
	CAIRO_STATUS_SURFACE_TYPE_MISMATCH,
	CAIRO_STATUS_PATTERN_TYPE_MISMATCH,
	CAIRO_STATUS_INVALID_CONTENT,
	CAIRO_STATUS_INVALID_FORMAT,
	CAIRO_STATUS_INVALID_VISUAL,
	CAIRO_STATUS_FILE_NOT_FOUND,
	CAIRO_STATUS_INVALID_DASH,
	CAIRO_STATUS_INVALID_DSC_COMMENT,
	CAIRO_STATUS_INVALID_INDEX,
	CAIRO_STATUS_CLIP_NOT_REPRESENTABLE,
	CAIRO_STATUS_TEMP_FILE_ERROR,
	CAIRO_STATUS_INVALID_STRIDE,
	CAIRO_STATUS_FONT_TYPE_MISMATCH,
	CAIRO_STATUS_USER_FONT_IMMUTABLE,
	CAIRO_STATUS_USER_FONT_ERROR,
	CAIRO_STATUS_NEGATIVE_COUNT,
	CAIRO_STATUS_INVALID_CLUSTERS,
	CAIRO_STATUS_INVALID_SLANT,
	CAIRO_STATUS_INVALID_WEIGHT,
	CAIRO_STATUS_INVALID_SIZE,
	CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED,
	CAIRO_STATUS_DEVICE_TYPE_MISMATCH,
	CAIRO_STATUS_DEVICE_ERROR,
	CAIRO_STATUS_INVALID_MESH_CONSTRUCTION,
	CAIRO_STATUS_DEVICE_FINISHED,
	CAIRO_STATUS_LAST_STATUS
}; typedef cairo_enum_t cairo_status_t;

typedef enum _cairo_content {
	CAIRO_CONTENT_COLOR = 0x1000,
	CAIRO_CONTENT_ALPHA = 0x2000,
	CAIRO_CONTENT_COLOR_ALPHA = 0x3000
}; typedef cairo_enum_t cairo_content_t;

typedef enum _cairo_format {
	CAIRO_FORMAT_INVALID = -1,
	CAIRO_FORMAT_ARGB32 = 0,
	CAIRO_FORMAT_RGB24 = 1,
	CAIRO_FORMAT_A8 = 2,
	CAIRO_FORMAT_A1 = 3,
	CAIRO_FORMAT_RGB16_565 = 4,
	CAIRO_FORMAT_RGB30 = 5
}; typedef cairo_enum_t cairo_format_t;

typedef cairo_status_t (*cairo_write_func_t) (void *closure, const void *data, unsigned int length);
typedef cairo_status_t (*cairo_read_func_t)  (void *closure, void *data, unsigned int length);

typedef struct _cairo_rectangle_int {
	int x, y;
	int width, height;
} cairo_rectangle_int_t;

cairo_t *         cairo_create                  (cairo_surface_t *target);
cairo_t *         cairo_reference               (cairo_t *cr);
void              cairo_destroy                 (cairo_t *cr);
unsigned int      cairo_get_reference_count     (cairo_t *cr);
void *            cairo_get_user_data           (cairo_t *cr, const cairo_user_data_key_t *key);
cairo_status_t    cairo_set_user_data           (cairo_t *cr, const cairo_user_data_key_t *key, void *user_data, cairo_destroy_func_t destroy);
void              cairo_save                    (cairo_t *cr);
void              cairo_restore                 (cairo_t *cr);
void              cairo_push_group              (cairo_t *cr);
void              cairo_push_group_with_content (cairo_t *cr, cairo_content_t content);
cairo_pattern_t * cairo_pop_group               (cairo_t *cr);
void              cairo_pop_group_to_source     (cairo_t *cr);

typedef enum _cairo_operator {
	CAIRO_OPERATOR_CLEAR,
	CAIRO_OPERATOR_SOURCE,
	CAIRO_OPERATOR_OVER,
	CAIRO_OPERATOR_IN,
	CAIRO_OPERATOR_OUT,
	CAIRO_OPERATOR_ATOP,
	CAIRO_OPERATOR_DEST,
	CAIRO_OPERATOR_DEST_OVER,
	CAIRO_OPERATOR_DEST_IN,
	CAIRO_OPERATOR_DEST_OUT,
	CAIRO_OPERATOR_DEST_ATOP,
	CAIRO_OPERATOR_XOR,
	CAIRO_OPERATOR_ADD,
	CAIRO_OPERATOR_SATURATE,
	CAIRO_OPERATOR_MULTIPLY,
	CAIRO_OPERATOR_SCREEN,
	CAIRO_OPERATOR_OVERLAY,
	CAIRO_OPERATOR_DARKEN,
	CAIRO_OPERATOR_LIGHTEN,
	CAIRO_OPERATOR_COLOR_DODGE,
	CAIRO_OPERATOR_COLOR_BURN,
	CAIRO_OPERATOR_HARD_LIGHT,
	CAIRO_OPERATOR_SOFT_LIGHT,
	CAIRO_OPERATOR_DIFFERENCE,
	CAIRO_OPERATOR_EXCLUSION,
	CAIRO_OPERATOR_HSL_HUE,
	CAIRO_OPERATOR_HSL_SATURATION,
	CAIRO_OPERATOR_HSL_COLOR,
	CAIRO_OPERATOR_HSL_LUMINOSITY,
}; typedef cairo_enum_t cairo_operator_t;

void cairo_set_operator       (cairo_t *cr, cairo_operator_t op);
void cairo_set_source         (cairo_t *cr, cairo_pattern_t *source);
void cairo_set_source_rgb     (cairo_t *cr, double red, double green, double blue);
void cairo_set_source_rgba    (cairo_t *cr, double red, double green, double blue, double alpha);
void cairo_set_source_surface (cairo_t *cr, cairo_surface_t *surface, double x, double y);
void cairo_set_tolerance      (cairo_t *cr, double tolerance);

typedef enum _cairo_antialias {
	CAIRO_ANTIALIAS_DEFAULT,
	CAIRO_ANTIALIAS_NONE,
	CAIRO_ANTIALIAS_GRAY,
	CAIRO_ANTIALIAS_SUBPIXEL,
	CAIRO_ANTIALIAS_FAST,
	CAIRO_ANTIALIAS_GOOD,
	CAIRO_ANTIALIAS_BEST
}; typedef cairo_enum_t cairo_antialias_t;

void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);

typedef enum _cairo_fill_rule {
	CAIRO_FILL_RULE_WINDING,
	CAIRO_FILL_RULE_EVEN_ODD
}; typedef cairo_enum_t cairo_fill_rule_t;

void cairo_set_fill_rule (cairo_t *cr, cairo_fill_rule_t fill_rule);
void cairo_set_line_width (cairo_t *cr, double width);

typedef enum _cairo_line_cap {
	CAIRO_LINE_CAP_BUTT,
	CAIRO_LINE_CAP_ROUND,
	CAIRO_LINE_CAP_SQUARE
}; typedef cairo_enum_t cairo_line_cap_t;

void cairo_set_line_cap (cairo_t *cr, cairo_line_cap_t line_cap);

typedef enum _cairo_line_join {
	CAIRO_LINE_JOIN_MITER,
	CAIRO_LINE_JOIN_ROUND,
	CAIRO_LINE_JOIN_BEVEL
}; typedef cairo_enum_t cairo_line_join_t;

void cairo_set_line_join (cairo_t *cr, cairo_line_join_t line_join);

void cairo_set_dash (cairo_t *cr, const double *dashes, int num_dashes, double offset);

void cairo_set_miter_limit (cairo_t *cr, double limit);

void cairo_translate       (cairo_t *cr, double tx, double ty);
void cairo_scale           (cairo_t *cr, double sx, double sy);
void cairo_rotate          (cairo_t *cr, double angle);
void cairo_transform       (cairo_t *cr, const cairo_matrix_t *matrix);
void cairo_set_matrix      (cairo_t *cr, const cairo_matrix_t *matrix);
void cairo_identity_matrix (cairo_t *cr);

void cairo_user_to_device          (cairo_t *cr, double *x, double *y);
void cairo_user_to_device_distance (cairo_t *cr, double *dx, double *dy);
void cairo_device_to_user          (cairo_t *cr, double *x, double *y);
void cairo_device_to_user_distance (cairo_t *cr, double *dx, double *dy);

void cairo_new_path     (cairo_t *cr);
void cairo_move_to      (cairo_t *cr, double x, double y);
void cairo_new_sub_path (cairo_t *cr);
void cairo_line_to      (cairo_t *cr, double x, double y);
void cairo_curve_to     (cairo_t *cr, double x1, double y1, double x2, double y2, double x3, double y3);
void cairo_arc          (cairo_t *cr, double xc, double yc, double radius, double angle1, double angle2);
void cairo_arc_negative (cairo_t *cr, double xc, double yc, double radius, double angle1, double angle2);
void cairo_rel_move_to  (cairo_t *cr, double dx, double dy);
void cairo_rel_line_to  (cairo_t *cr, double dx, double dy);
void cairo_rel_curve_to (cairo_t *cr, double dx1, double dy1, double dx2, double dy2, double dx3, double dy3);
void cairo_rectangle    (cairo_t *cr, double x, double y, double width, double height);
void cairo_close_path   (cairo_t *cr);
void cairo_path_extents (cairo_t *cr, double *x1, double *y1, double *x2, double *y2);

void cairo_paint            (cairo_t *cr);
void cairo_paint_with_alpha (cairo_t *cr, double alpha);

void cairo_mask         (cairo_t *cr, cairo_pattern_t *pattern);
void cairo_mask_surface (cairo_t *cr, cairo_surface_t *surface, double surface_x, double surface_y);

void cairo_stroke          (cairo_t *cr);
void cairo_stroke_preserve (cairo_t *cr);
void cairo_fill            (cairo_t *cr);
void cairo_fill_preserve   (cairo_t *cr);

void cairo_copy_page (cairo_t *cr);
void cairo_show_page (cairo_t *cr);

cairo_bool_t cairo_in_stroke (cairo_t *cr, double x, double y);
cairo_bool_t cairo_in_fill   (cairo_t *cr, double x, double y);
cairo_bool_t cairo_in_clip   (cairo_t *cr, double x, double y);

void cairo_stroke_extents    (cairo_t *cr, double *x1, double *y1, double *x2, double *y2);
void cairo_fill_extents      (cairo_t *cr, double *x1, double *y1, double *x2, double *y2);

void cairo_reset_clip    (cairo_t *cr);
void cairo_clip          (cairo_t *cr);
void cairo_clip_preserve (cairo_t *cr);
void cairo_clip_extents  (cairo_t *cr, double *x1, double *y1, double *x2, double *y2);

typedef struct _cairo_rectangle {
	double x, y, width, height;
} cairo_rectangle_t;

typedef struct _cairo_rectangle_list {
	cairo_status_t status;
	cairo_rectangle_t *rectangles;
	int num_rectangles;
} cairo_rectangle_list_t;

cairo_rectangle_list_t * cairo_copy_clip_rectangle_list (cairo_t *cr);
void                     cairo_rectangle_list_destroy   (cairo_rectangle_list_t *rectangle_list);

typedef struct _cairo_scaled_font cairo_scaled_font_t;
typedef struct _cairo_font_face cairo_font_face_t;
typedef struct {
	unsigned long index;
	double x;
	double y;
} cairo_glyph_t;

cairo_glyph_t * cairo_glyph_allocate (int num_glyphs);
void            cairo_glyph_free     (cairo_glyph_t *glyphs);

typedef struct {
	int num_bytes;
	int num_glyphs;
} cairo_text_cluster_t;

cairo_text_cluster_t * cairo_text_cluster_allocate (int num_clusters);
void                   cairo_text_cluster_free (cairo_text_cluster_t *clusters);

typedef enum _cairo_text_cluster_flags {
	CAIRO_TEXT_CLUSTER_FLAG_BACKWARD = 0x00000001
}; typedef cairo_enum_t cairo_text_cluster_flags_t;

typedef struct {
	double x_bearing;
	double y_bearing;
	double width;
	double height;
	double x_advance;
	double y_advance;
} cairo_text_extents_t;

typedef struct {
	double ascent;
	double descent;
	double height;
	double max_x_advance;
	double max_y_advance;
} cairo_font_extents_t;

typedef enum _cairo_font_slant {
	CAIRO_FONT_SLANT_NORMAL,
	CAIRO_FONT_SLANT_ITALIC,
	CAIRO_FONT_SLANT_OBLIQUE
}; typedef cairo_enum_t cairo_font_slant_t;

typedef enum _cairo_font_weight {
	CAIRO_FONT_WEIGHT_NORMAL,
	CAIRO_FONT_WEIGHT_BOLD
}; typedef cairo_enum_t cairo_font_weight_t;

typedef enum _cairo_subpixel_order {
	CAIRO_SUBPIXEL_ORDER_DEFAULT,
	CAIRO_SUBPIXEL_ORDER_RGB,
	CAIRO_SUBPIXEL_ORDER_BGR,
	CAIRO_SUBPIXEL_ORDER_VRGB,
	CAIRO_SUBPIXEL_ORDER_VBGR
}; typedef cairo_enum_t cairo_subpixel_order_t;

typedef enum _cairo_hint_style {
	CAIRO_HINT_STYLE_DEFAULT,
	CAIRO_HINT_STYLE_NONE,
	CAIRO_HINT_STYLE_SLIGHT,
	CAIRO_HINT_STYLE_MEDIUM,
	CAIRO_HINT_STYLE_FULL
}; typedef cairo_enum_t cairo_hint_style_t;

typedef enum _cairo_hint_metrics {
	CAIRO_HINT_METRICS_DEFAULT,
	CAIRO_HINT_METRICS_OFF,
	CAIRO_HINT_METRICS_ON
}; typedef cairo_enum_t cairo_hint_metrics_t;

typedef struct _cairo_font_options cairo_font_options_t;

cairo_font_options_t *    cairo_font_options_create             (void);
cairo_font_options_t *    cairo_font_options_copy               (const cairo_font_options_t *original);
void                      cairo_font_options_destroy            (cairo_font_options_t *options);
cairo_status_t            cairo_font_options_status             (cairo_font_options_t *options);
void                      cairo_font_options_merge              (cairo_font_options_t *options, const cairo_font_options_t *other);
cairo_bool_t              cairo_font_options_equal              (const cairo_font_options_t *options, const cairo_font_options_t *other);
unsigned long             cairo_font_options_hash               (const cairo_font_options_t *options);
void                      cairo_font_options_set_antialias      (cairo_font_options_t *options, cairo_antialias_t antialias);
cairo_antialias_t         cairo_font_options_get_antialias      (const cairo_font_options_t *options);
void                      cairo_font_options_set_subpixel_order (cairo_font_options_t *options, cairo_subpixel_order_t subpixel_order);
cairo_subpixel_order_t    cairo_font_options_get_subpixel_order (const cairo_font_options_t *options);
void                      cairo_font_options_set_hint_style     (cairo_font_options_t *options, cairo_hint_style_t hint_style);
cairo_hint_style_t        cairo_font_options_get_hint_style     (const cairo_font_options_t *options);
void                      cairo_font_options_set_hint_metrics   (cairo_font_options_t *options, cairo_hint_metrics_t hint_metrics);
cairo_hint_metrics_t      cairo_font_options_get_hint_metrics   (const cairo_font_options_t *options);
void                      cairo_select_font_face                (cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight);
void                      cairo_set_font_size                   (cairo_t *cr, double size);
void                      cairo_set_font_matrix                 (cairo_t *cr, const cairo_matrix_t *matrix);
void                      cairo_get_font_matrix                 (cairo_t *cr, cairo_matrix_t *matrix);
void                      cairo_set_font_options                (cairo_t *cr, const cairo_font_options_t *options);
void                      cairo_get_font_options                (cairo_t *cr, cairo_font_options_t *options);
void                      cairo_set_font_face                   (cairo_t *cr, cairo_font_face_t *font_face);
cairo_font_face_t *       cairo_get_font_face                   (cairo_t *cr);
void                      cairo_set_scaled_font                 (cairo_t *cr, const cairo_scaled_font_t *scaled_font);
cairo_scaled_font_t *     cairo_get_scaled_font                 (cairo_t *cr);
void                      cairo_show_text                       (cairo_t *cr, const char *utf8);
void                      cairo_show_glyphs                     (cairo_t *cr, const cairo_glyph_t *glyphs, int num_glyphs);
void                      cairo_show_text_glyphs                (cairo_t *cr, const char *utf8, int utf8_len, const cairo_glyph_t *glyphs, int num_glyphs, const cairo_text_cluster_t *clusters, int num_clusters, cairo_text_cluster_flags_t cluster_flags);
void                      cairo_text_path                       (cairo_t *cr, const char *utf8);
void                      cairo_glyph_path                      (cairo_t *cr, const cairo_glyph_t *glyphs, int num_glyphs);
void                      cairo_text_extents                    (cairo_t *cr, const char *utf8, cairo_text_extents_t *extents);
void                      cairo_glyph_extents                   (cairo_t *cr, const cairo_glyph_t *glyphs, int num_glyphs, cairo_text_extents_t *extents);
void                      cairo_font_extents                    (cairo_t *cr, cairo_font_extents_t *extents);
cairo_font_face_t *       cairo_font_face_reference             (cairo_font_face_t *font_face);
void                      cairo_font_face_destroy               (cairo_font_face_t *font_face);
unsigned int              cairo_font_face_get_reference_count   (cairo_font_face_t *font_face);
cairo_status_t            cairo_font_face_status                (cairo_font_face_t *font_face);

typedef enum _cairo_font_type {
	CAIRO_FONT_TYPE_TOY,
	CAIRO_FONT_TYPE_FT,
	CAIRO_FONT_TYPE_WIN32,
	CAIRO_FONT_TYPE_QUARTZ,
	CAIRO_FONT_TYPE_USER
}; typedef cairo_enum_t cairo_font_type_t;

cairo_font_type_t cairo_font_face_get_type      (cairo_font_face_t *font_face);
void *            cairo_font_face_get_user_data (cairo_font_face_t *font_face, const cairo_user_data_key_t *key);
cairo_status_t    cairo_font_face_set_user_data (cairo_font_face_t *font_face, const cairo_user_data_key_t *key, void *user_data, cairo_destroy_func_t destroy);

cairo_scaled_font_t * cairo_scaled_font_create              (cairo_font_face_t *font_face, const cairo_matrix_t *font_matrix, const cairo_matrix_t *ctm, const cairo_font_options_t *options);
cairo_scaled_font_t * cairo_scaled_font_reference           (cairo_scaled_font_t *scaled_font);
void                  cairo_scaled_font_destroy             (cairo_scaled_font_t *scaled_font);
unsigned int          cairo_scaled_font_get_reference_count (cairo_scaled_font_t *scaled_font);
cairo_status_t        cairo_scaled_font_status              (cairo_scaled_font_t *scaled_font);
cairo_font_type_t     cairo_scaled_font_get_type            (cairo_scaled_font_t *scaled_font);
void *                cairo_scaled_font_get_user_data       (cairo_scaled_font_t *scaled_font, const cairo_user_data_key_t *key);
cairo_status_t        cairo_scaled_font_set_user_data       (cairo_scaled_font_t *scaled_font, const cairo_user_data_key_t *key, void *user_data, cairo_destroy_func_t destroy);
void                  cairo_scaled_font_extents             (cairo_scaled_font_t *scaled_font, cairo_font_extents_t *extents);
void                  cairo_scaled_font_text_extents        (cairo_scaled_font_t *scaled_font, const char *utf8, cairo_text_extents_t *extents);
void                  cairo_scaled_font_glyph_extents       (cairo_scaled_font_t *scaled_font, const cairo_glyph_t *glyphs, int num_glyphs, cairo_text_extents_t *extents);
cairo_status_t        cairo_scaled_font_text_to_glyphs      (cairo_scaled_font_t *scaled_font, double x, double y, const char *utf8, int utf8_len, cairo_glyph_t **glyphs, int *num_glyphs, cairo_text_cluster_t **clusters, int *num_clusters, cairo_text_cluster_flags_t *cluster_flags);
cairo_font_face_t *   cairo_scaled_font_get_font_face       (cairo_scaled_font_t *scaled_font);
void                  cairo_scaled_font_get_font_matrix     (cairo_scaled_font_t *scaled_font, cairo_matrix_t *font_matrix);
void                  cairo_scaled_font_get_ctm             (cairo_scaled_font_t *scaled_font, cairo_matrix_t *ctm);
void                  cairo_scaled_font_get_scale_matrix    (cairo_scaled_font_t *scaled_font, cairo_matrix_t *scale_matrix);
void                  cairo_scaled_font_get_font_options    (cairo_scaled_font_t *scaled_font, cairo_font_options_t *options);

cairo_font_face_t * cairo_toy_font_face_create     (const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight);
const char *        cairo_toy_font_face_get_family (cairo_font_face_t *font_face);
cairo_font_slant_t  cairo_toy_font_face_get_slant  (cairo_font_face_t *font_face);
cairo_font_weight_t cairo_toy_font_face_get_weight (cairo_font_face_t *font_face);

typedef cairo_status_t (*cairo_user_scaled_font_init_func_t)             (cairo_scaled_font_t *scaled_font, cairo_t *cr, cairo_font_extents_t *extents);
typedef cairo_status_t (*cairo_user_scaled_font_render_glyph_func_t)     (cairo_scaled_font_t *scaled_font, unsigned long glyph, cairo_t *cr, cairo_text_extents_t *extents);
typedef cairo_status_t (*cairo_user_scaled_font_text_to_glyphs_func_t)   (cairo_scaled_font_t *scaled_font, const char *utf8, int utf8_len, cairo_glyph_t **glyphs, int *num_glyphs, cairo_text_cluster_t **clusters, int *num_clusters, cairo_text_cluster_flags_t *cluster_flags);
typedef cairo_status_t (*cairo_user_scaled_font_unicode_to_glyph_func_t) (cairo_scaled_font_t *scaled_font, unsigned long unicode, unsigned long *glyph_index);

cairo_font_face_t * cairo_user_font_face_create                    (void);
void                cairo_user_font_face_set_init_func             (cairo_font_face_t *font_face, cairo_user_scaled_font_init_func_t init_func);
void                cairo_user_font_face_set_render_glyph_func     (cairo_font_face_t *font_face, cairo_user_scaled_font_render_glyph_func_t render_glyph_func);
void                cairo_user_font_face_set_text_to_glyphs_func   (cairo_font_face_t *font_face, cairo_user_scaled_font_text_to_glyphs_func_t text_to_glyphs_func);
void                cairo_user_font_face_set_unicode_to_glyph_func (cairo_font_face_t *font_face, cairo_user_scaled_font_unicode_to_glyph_func_t unicode_to_glyph_func);

cairo_user_scaled_font_init_func_t             cairo_user_font_face_get_init_func             (cairo_font_face_t *font_face);
cairo_user_scaled_font_render_glyph_func_t     cairo_user_font_face_get_render_glyph_func     (cairo_font_face_t *font_face);
cairo_user_scaled_font_text_to_glyphs_func_t   cairo_user_font_face_get_text_to_glyphs_func   (cairo_font_face_t *font_face);
cairo_user_scaled_font_unicode_to_glyph_func_t cairo_user_font_face_get_unicode_to_glyph_func (cairo_font_face_t *font_face);

cairo_operator_t  cairo_get_operator      (cairo_t *cr);
cairo_pattern_t * cairo_get_source        (cairo_t *cr);
double            cairo_get_tolerance     (cairo_t *cr);
cairo_antialias_t cairo_get_antialias     (cairo_t *cr);
cairo_bool_t      cairo_has_current_point (cairo_t *cr);
void              cairo_get_current_point (cairo_t *cr, double *x, double *y);
cairo_fill_rule_t cairo_get_fill_rule     (cairo_t *cr);
double            cairo_get_line_width    (cairo_t *cr);
cairo_line_cap_t  cairo_get_line_cap      (cairo_t *cr);
cairo_line_join_t cairo_get_line_join     (cairo_t *cr);
double            cairo_get_miter_limit   (cairo_t *cr);
int               cairo_get_dash_count    (cairo_t *cr);
void              cairo_get_dash          (cairo_t *cr, double *dashes, double *offset);
void              cairo_get_matrix        (cairo_t *cr, cairo_matrix_t *matrix);
cairo_surface_t * cairo_get_target        (cairo_t *cr);
cairo_surface_t * cairo_get_group_target  (cairo_t *cr);

typedef enum _cairo_path_data_type {
	CAIRO_PATH_MOVE_TO,
	CAIRO_PATH_LINE_TO,
	CAIRO_PATH_CURVE_TO,
	CAIRO_PATH_CLOSE_PATH
}; typedef cairo_enum_t cairo_path_data_type_t;

typedef union _cairo_path_data_t cairo_path_data_t;

union _cairo_path_data_t {
	struct {
		cairo_path_data_type_t type;
		int length;
	} header;
	struct {
		double x, y;
	} point;
	struct {
		int64_t e1, e2;
	} opaque;
};

typedef struct cairo_path {
	cairo_status_t status;
	cairo_path_data_t *data;
	int num_data;
} cairo_path_t;

cairo_path_t * cairo_copy_path      (cairo_t *cr);
cairo_path_t * cairo_copy_path_flat (cairo_t *cr);
void           cairo_append_path    (cairo_t *cr, const cairo_path_t *path);
void           cairo_path_destroy   (cairo_path_t *path);

cairo_status_t cairo_status           (cairo_t *cr);
const char *   cairo_status_to_string (cairo_status_t status);

typedef enum _cairo_device_type {
	CAIRO_DEVICE_TYPE_DRM,
	CAIRO_DEVICE_TYPE_GL,
	CAIRO_DEVICE_TYPE_SCRIPT,
	CAIRO_DEVICE_TYPE_XCB,
	CAIRO_DEVICE_TYPE_XLIB,
	CAIRO_DEVICE_TYPE_XML,
	CAIRO_DEVICE_TYPE_COGL,
	CAIRO_DEVICE_TYPE_WIN32,
	CAIRO_DEVICE_TYPE_INVALID = -1
}; typedef cairo_enum_t cairo_device_type_t;

cairo_device_t *    cairo_device_reference           (cairo_device_t *device);
cairo_device_type_t cairo_device_get_type            (cairo_device_t *device);
cairo_status_t      cairo_device_status              (cairo_device_t *device);
cairo_status_t      cairo_device_acquire             (cairo_device_t *device);
void                cairo_device_release             (cairo_device_t *device);
void                cairo_device_flush               (cairo_device_t *device);
void                cairo_device_finish              (cairo_device_t *device);
void                cairo_device_destroy             (cairo_device_t *device);
unsigned int        cairo_device_get_reference_count (cairo_device_t *device);
void *              cairo_device_get_user_data       (cairo_device_t *device, const cairo_user_data_key_t *key);
cairo_status_t      cairo_device_set_user_data       (cairo_device_t *device, const cairo_user_data_key_t *key, void *user_data, cairo_destroy_func_t destroy);

cairo_surface_t * cairo_surface_create_similar       (cairo_surface_t *other, cairo_content_t content, int width, int height);
cairo_surface_t * cairo_surface_create_similar_image (cairo_surface_t *other, cairo_format_t format, int width, int height);
cairo_surface_t * cairo_surface_map_to_image         (cairo_surface_t *surface, const cairo_rectangle_int_t *extents);
void              cairo_surface_unmap_image          (cairo_surface_t *surface, cairo_surface_t *image);
cairo_surface_t * cairo_surface_create_for_rectangle (cairo_surface_t *target, double x, double y, double width, double height);

typedef enum _cairo_surface_observer {
 CAIRO_SURFACE_OBSERVER_NORMAL = 0,
 CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS = 0x1
}; typedef cairo_enum_t cairo_surface_observer_mode_t;

cairo_surface_t * cairo_surface_create_observer (cairo_surface_t *target, cairo_surface_observer_mode_t mode);

typedef void (*cairo_surface_observer_callback_t) (cairo_surface_t *observer, cairo_surface_t *target, void *data);

cairo_status_t cairo_surface_observer_add_paint_callback  (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);
cairo_status_t cairo_surface_observer_add_mask_callback   (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);
cairo_status_t cairo_surface_observer_add_fill_callback   (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);
cairo_status_t cairo_surface_observer_add_stroke_callback (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);
cairo_status_t cairo_surface_observer_add_glyphs_callback (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);
cairo_status_t cairo_surface_observer_add_flush_callback  (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);
cairo_status_t cairo_surface_observer_add_finish_callback (cairo_surface_t *abstract_surface, cairo_surface_observer_callback_t func, void *data);

cairo_status_t cairo_surface_observer_print   (cairo_surface_t *surface, cairo_write_func_t write_func, void *closure);
double         cairo_surface_observer_elapsed (cairo_surface_t *surface);

cairo_status_t cairo_device_observer_print          (cairo_device_t *device, cairo_write_func_t write_func, void *closure);
double         cairo_device_observer_elapsed        (cairo_device_t *device);
double         cairo_device_observer_paint_elapsed  (cairo_device_t *device);
double         cairo_device_observer_mask_elapsed   (cairo_device_t *device);
double         cairo_device_observer_fill_elapsed   (cairo_device_t *device);
double         cairo_device_observer_stroke_elapsed (cairo_device_t *device);
double         cairo_device_observer_glyphs_elapsed (cairo_device_t *device);

cairo_surface_t * cairo_surface_reference           (cairo_surface_t *surface);
void              cairo_surface_finish              (cairo_surface_t *surface);
void              cairo_surface_destroy             (cairo_surface_t *surface);
cairo_device_t *  cairo_surface_get_device          (cairo_surface_t *surface);
unsigned int      cairo_surface_get_reference_count (cairo_surface_t *surface);
cairo_status_t    cairo_surface_status              (cairo_surface_t *surface);

typedef enum _cairo_surface_type {
	CAIRO_SURFACE_TYPE_IMAGE,
	CAIRO_SURFACE_TYPE_PDF,
	CAIRO_SURFACE_TYPE_PS,
	CAIRO_SURFACE_TYPE_XLIB,
	CAIRO_SURFACE_TYPE_XCB,
	CAIRO_SURFACE_TYPE_GLITZ,
	CAIRO_SURFACE_TYPE_QUARTZ,
	CAIRO_SURFACE_TYPE_WIN32,
	CAIRO_SURFACE_TYPE_BEOS,
	CAIRO_SURFACE_TYPE_DIRECTFB,
	CAIRO_SURFACE_TYPE_SVG,
	CAIRO_SURFACE_TYPE_OS2,
	CAIRO_SURFACE_TYPE_WIN32_PRINTING,
	CAIRO_SURFACE_TYPE_QUARTZ_IMAGE,
	CAIRO_SURFACE_TYPE_SCRIPT,
	CAIRO_SURFACE_TYPE_QT,
	CAIRO_SURFACE_TYPE_RECORDING,
	CAIRO_SURFACE_TYPE_VG,
	CAIRO_SURFACE_TYPE_GL,
	CAIRO_SURFACE_TYPE_DRM,
	CAIRO_SURFACE_TYPE_TEE,
	CAIRO_SURFACE_TYPE_XML,
	CAIRO_SURFACE_TYPE_SKIA,
	CAIRO_SURFACE_TYPE_SUBSURFACE,
	CAIRO_SURFACE_TYPE_COGL
}; typedef cairo_enum_t cairo_surface_type_t;

cairo_surface_type_t cairo_surface_get_type                (cairo_surface_t *surface);
cairo_content_t      cairo_surface_get_content             (cairo_surface_t *surface);
cairo_status_t       cairo_surface_write_to_png            (cairo_surface_t *surface, const char *filename);
cairo_status_t       cairo_surface_write_to_png_stream     (cairo_surface_t *surface, cairo_write_func_t write_func, void *closure);
void *               cairo_surface_get_user_data           (cairo_surface_t *surface, const cairo_user_data_key_t *key);
cairo_status_t       cairo_surface_set_user_data           (cairo_surface_t *surface, const cairo_user_data_key_t *key, void *user_data, cairo_destroy_func_t destroy);
void                 cairo_surface_get_mime_data           (cairo_surface_t *surface, const char *mime_type, const void **data, unsigned long *length);
cairo_status_t       cairo_surface_set_mime_data           (cairo_surface_t *surface, const char *mime_type, const void *data, unsigned long length, cairo_destroy_func_t destroy, void *closure);
cairo_bool_t         cairo_surface_supports_mime_type      (cairo_surface_t *surface, const char *mime_type);
void                 cairo_surface_get_font_options        (cairo_surface_t *surface, cairo_font_options_t *options);
void                 cairo_surface_flush                   (cairo_surface_t *surface);
void                 cairo_surface_mark_dirty              (cairo_surface_t *surface);
void                 cairo_surface_mark_dirty_rectangle    (cairo_surface_t *surface, int x, int y, int width, int height);
void                 cairo_surface_set_device_offset       (cairo_surface_t *surface, double x_offset, double y_offset);
void                 cairo_surface_get_device_offset       (cairo_surface_t *surface, double *x_offset, double *y_offset);
void                 cairo_surface_set_fallback_resolution (cairo_surface_t *surface, double x_pixels_per_inch, double y_pixels_per_inch);
void                 cairo_surface_get_fallback_resolution (cairo_surface_t *surface, double *x_pixels_per_inch, double *y_pixels_per_inch);
void                 cairo_surface_copy_page               (cairo_surface_t *surface);
void                 cairo_surface_show_page               (cairo_surface_t *surface);
cairo_bool_t         cairo_surface_has_show_text_glyphs    (cairo_surface_t *surface);

int cairo_format_stride_for_width (cairo_format_t format, int width);

cairo_surface_t * cairo_image_surface_create                 (cairo_format_t format, int width, int height);
cairo_surface_t * cairo_image_surface_create_for_data        (void *data, cairo_format_t format, int width, int height, int stride);
void *            cairo_image_surface_get_data               (cairo_surface_t *surface);
cairo_format_t    cairo_image_surface_get_format             (cairo_surface_t *surface);
int               cairo_image_surface_get_width              (cairo_surface_t *surface);
int               cairo_image_surface_get_height             (cairo_surface_t *surface);
int               cairo_image_surface_get_stride             (cairo_surface_t *surface);
cairo_surface_t * cairo_image_surface_create_from_png        (const char *filename);
cairo_surface_t * cairo_image_surface_create_from_png_stream (cairo_read_func_t read_func, void *closure);

cairo_surface_t * cairo_recording_surface_create      (cairo_content_t content, const cairo_rectangle_t *extents);
void              cairo_recording_surface_ink_extents (cairo_surface_t *surface, double *x0, double *y0, double *width, double *height);
cairo_bool_t      cairo_recording_surface_get_extents (cairo_surface_t *surface, cairo_rectangle_t *extents);

typedef cairo_surface_t * (*cairo_raster_source_acquire_func_t)  (cairo_pattern_t *pattern, void *callback_data, cairo_surface_t *target, const cairo_rectangle_int_t *extents);
typedef void              (*cairo_raster_source_release_func_t)  (cairo_pattern_t *pattern, void *callback_data, cairo_surface_t *surface);
typedef cairo_status_t    (*cairo_raster_source_snapshot_func_t) (cairo_pattern_t *pattern, void *callback_data);
typedef cairo_status_t    (*cairo_raster_source_copy_func_t)     (cairo_pattern_t *pattern, void *callback_data, const cairo_pattern_t *other);
typedef void              (*cairo_raster_source_finish_func_t)   (cairo_pattern_t *pattern, void *callback_data);

cairo_pattern_t *                   cairo_pattern_create_raster_source            (void *user_data, cairo_content_t content, int width, int height);
void                                cairo_raster_source_pattern_set_callback_data (cairo_pattern_t *pattern, void *data);
void *                              cairo_raster_source_pattern_get_callback_data (cairo_pattern_t *pattern);
void                                cairo_raster_source_pattern_set_acquire       (cairo_pattern_t *pattern, cairo_raster_source_acquire_func_t acquire, cairo_raster_source_release_func_t release);
void                                cairo_raster_source_pattern_get_acquire       (cairo_pattern_t *pattern, cairo_raster_source_acquire_func_t *acquire, cairo_raster_source_release_func_t *release);
void                                cairo_raster_source_pattern_set_snapshot      (cairo_pattern_t *pattern, cairo_raster_source_snapshot_func_t snapshot);
cairo_raster_source_snapshot_func_t cairo_raster_source_pattern_get_snapshot      (cairo_pattern_t *pattern);
void                                cairo_raster_source_pattern_set_copy          (cairo_pattern_t *pattern, cairo_raster_source_copy_func_t copy);
cairo_raster_source_copy_func_t     cairo_raster_source_pattern_get_copy          (cairo_pattern_t *pattern);
void                                cairo_raster_source_pattern_set_finish        (cairo_pattern_t *pattern, cairo_raster_source_finish_func_t finish);
cairo_raster_source_finish_func_t   cairo_raster_source_pattern_get_finish        (cairo_pattern_t *pattern);

cairo_pattern_t * cairo_pattern_create_rgb          (double red, double green, double blue);
cairo_pattern_t * cairo_pattern_create_rgba         (double red, double green, double blue, double alpha);
cairo_pattern_t * cairo_pattern_create_for_surface  (cairo_surface_t *surface);
cairo_pattern_t * cairo_pattern_create_linear       (double x0, double y0, double x1, double y1);
cairo_pattern_t * cairo_pattern_create_radial       (double cx0, double cy0, double radius0, double cx1, double cy1, double radius1);
cairo_pattern_t * cairo_pattern_create_mesh         (void);
cairo_pattern_t * cairo_pattern_reference           (cairo_pattern_t *pattern);
void              cairo_pattern_destroy             (cairo_pattern_t *pattern);
unsigned int      cairo_pattern_get_reference_count (cairo_pattern_t *pattern);
cairo_status_t    cairo_pattern_status              (cairo_pattern_t *pattern);
void *            cairo_pattern_get_user_data       (cairo_pattern_t *pattern, const cairo_user_data_key_t *key);
cairo_status_t    cairo_pattern_set_user_data       (cairo_pattern_t *pattern, const cairo_user_data_key_t *key, void *user_data, cairo_destroy_func_t destroy);

typedef enum _cairo_pattern_type {
	CAIRO_PATTERN_TYPE_SOLID,
	CAIRO_PATTERN_TYPE_SURFACE,
	CAIRO_PATTERN_TYPE_LINEAR,
	CAIRO_PATTERN_TYPE_RADIAL,
	CAIRO_PATTERN_TYPE_MESH,
	CAIRO_PATTERN_TYPE_RASTER_SOURCE
}; typedef cairo_enum_t cairo_pattern_type_t;

cairo_pattern_type_t cairo_pattern_get_type (cairo_pattern_t *pattern);

void cairo_pattern_add_color_stop_rgb  (cairo_pattern_t *pattern, double offset, double red, double green, double blue);
void cairo_pattern_add_color_stop_rgba (cairo_pattern_t *pattern, double offset, double red, double green, double blue, double alpha);

void cairo_mesh_pattern_begin_patch           (cairo_pattern_t *pattern);
void cairo_mesh_pattern_end_patch             (cairo_pattern_t *pattern);
void cairo_mesh_pattern_curve_to              (cairo_pattern_t *pattern, double x1, double y1, double x2, double y2, double x3, double y3);
void cairo_mesh_pattern_line_to               (cairo_pattern_t *pattern, double x, double y);
void cairo_mesh_pattern_move_to               (cairo_pattern_t *pattern, double x, double y);
void cairo_mesh_pattern_set_control_point     (cairo_pattern_t *pattern, unsigned int point_num, double x, double y);
void cairo_mesh_pattern_set_corner_color_rgb  (cairo_pattern_t *pattern, unsigned int corner_num, double red, double green, double blue);
void cairo_mesh_pattern_set_corner_color_rgba (cairo_pattern_t *pattern, unsigned int corner_num, double red, double green, double blue, double alpha);

void cairo_pattern_set_matrix (cairo_pattern_t *pattern, const cairo_matrix_t *matrix);
void cairo_pattern_get_matrix (cairo_pattern_t *pattern, cairo_matrix_t *matrix);

typedef enum _cairo_extend {
	CAIRO_EXTEND_NONE,
	CAIRO_EXTEND_REPEAT,
	CAIRO_EXTEND_REFLECT,
	CAIRO_EXTEND_PAD
}; typedef cairo_enum_t cairo_extend_t;

void           cairo_pattern_set_extend (cairo_pattern_t *pattern, cairo_extend_t extend);
cairo_extend_t cairo_pattern_get_extend (cairo_pattern_t *pattern);

typedef enum _cairo_filter {
	CAIRO_FILTER_FAST,
	CAIRO_FILTER_GOOD,
	CAIRO_FILTER_BEST,
	CAIRO_FILTER_NEAREST,
	CAIRO_FILTER_BILINEAR,
	CAIRO_FILTER_GAUSSIAN
}; typedef cairo_enum_t cairo_filter_t;

void           cairo_pattern_set_filter                 (cairo_pattern_t *pattern, cairo_filter_t filter);
cairo_filter_t cairo_pattern_get_filter                 (cairo_pattern_t *pattern);
cairo_status_t cairo_pattern_get_rgba                   (cairo_pattern_t *pattern, double *red, double *green, double *blue, double *alpha);
cairo_status_t cairo_pattern_get_surface                (cairo_pattern_t *pattern, cairo_surface_t **surface);
cairo_status_t cairo_pattern_get_color_stop_rgba        (cairo_pattern_t *pattern, int index, double *offset, double *red, double *green, double *blue, double *alpha);
cairo_status_t cairo_pattern_get_color_stop_count       (cairo_pattern_t *pattern, int *count);
cairo_status_t cairo_pattern_get_linear_points          (cairo_pattern_t *pattern, double *x0, double *y0, double *x1, double *y1);
cairo_status_t cairo_pattern_get_radial_circles         (cairo_pattern_t *pattern, double *x0, double *y0, double *r0, double *x1, double *y1, double *r1);
cairo_status_t cairo_mesh_pattern_get_patch_count       (cairo_pattern_t *pattern, unsigned int *count);
cairo_path_t * cairo_mesh_pattern_get_path              (cairo_pattern_t *pattern, unsigned int patch_num);
cairo_status_t cairo_mesh_pattern_get_corner_color_rgba (cairo_pattern_t *pattern, unsigned int patch_num, unsigned int corner_num, double *red, double *green, double *blue, double *alpha);
cairo_status_t cairo_mesh_pattern_get_control_point     (cairo_pattern_t *pattern, unsigned int patch_num, unsigned int point_num, double *x, double *y);

void           cairo_matrix_init               (cairo_matrix_t *matrix, double xx, double yx, double xy, double yy, double x0, double y0);
void           cairo_matrix_init_identity      (cairo_matrix_t *matrix);
void           cairo_matrix_init_translate     (cairo_matrix_t *matrix, double tx, double ty);
void           cairo_matrix_init_scale         (cairo_matrix_t *matrix, double sx, double sy);
void           cairo_matrix_init_rotate        (cairo_matrix_t *matrix, double radians);
void           cairo_matrix_translate          (cairo_matrix_t *matrix, double tx, double ty);
void           cairo_matrix_scale              (cairo_matrix_t *matrix, double sx, double sy);
void           cairo_matrix_rotate             (cairo_matrix_t *matrix, double radians);
cairo_status_t cairo_matrix_invert             (cairo_matrix_t *matrix);
void           cairo_matrix_multiply           (cairo_matrix_t *result, const cairo_matrix_t *a, const cairo_matrix_t *b);
void           cairo_matrix_transform_distance (const cairo_matrix_t *matrix, double *dx, double *dy);
void           cairo_matrix_transform_point    (const cairo_matrix_t *matrix, double *x, double *y);

typedef struct _cairo_region cairo_region_t;

typedef enum _cairo_region_overlap {
	CAIRO_REGION_OVERLAP_IN,
	CAIRO_REGION_OVERLAP_OUT,
	CAIRO_REGION_OVERLAP_PART
}; typedef cairo_enum_t cairo_region_overlap_t;

cairo_region_t *       cairo_region_create              (void);
cairo_region_t *       cairo_region_create_rectangle    (const cairo_rectangle_int_t *rectangle);
cairo_region_t *       cairo_region_create_rectangles   (const cairo_rectangle_int_t *rects, int count);
cairo_region_t *       cairo_region_copy                (const cairo_region_t *original);
cairo_region_t *       cairo_region_reference           (cairo_region_t *region);
void                   cairo_region_destroy             (cairo_region_t *region);
cairo_bool_t           cairo_region_equal               (const cairo_region_t *a, const cairo_region_t *b);
cairo_status_t         cairo_region_status              (const cairo_region_t *region);
void                   cairo_region_get_extents         (const cairo_region_t *region, cairo_rectangle_int_t *extents);
int                    cairo_region_num_rectangles      (const cairo_region_t *region);
void                   cairo_region_get_rectangle       (const cairo_region_t *region, int nth, cairo_rectangle_int_t *rectangle);
cairo_bool_t           cairo_region_is_empty            (const cairo_region_t *region);
cairo_region_overlap_t cairo_region_contains_rectangle  (const cairo_region_t *region, const cairo_rectangle_int_t *rectangle);
cairo_bool_t           cairo_region_contains_point      (const cairo_region_t *region, int x, int y);
void                   cairo_region_translate           (cairo_region_t *region, int dx, int dy);
cairo_status_t         cairo_region_subtract            (cairo_region_t *dst, const cairo_region_t *other);
cairo_status_t         cairo_region_subtract_rectangle  (cairo_region_t *dst, const cairo_rectangle_int_t *rectangle);
cairo_status_t         cairo_region_intersect           (cairo_region_t *dst, const cairo_region_t *other);
cairo_status_t         cairo_region_intersect_rectangle (cairo_region_t *dst, const cairo_rectangle_int_t *rectangle);
cairo_status_t         cairo_region_union               (cairo_region_t *dst, const cairo_region_t *other);
cairo_status_t         cairo_region_union_rectangle     (cairo_region_t *dst, const cairo_rectangle_int_t *rectangle);
cairo_status_t         cairo_region_xor                 (cairo_region_t *dst, const cairo_region_t *other);
cairo_status_t         cairo_region_xor_rectangle       (cairo_region_t *dst, const cairo_rectangle_int_t *rectangle);

void                   cairo_debug_reset_static_data    (void);

// private APIs

typedef enum _cairo_lcd_filter {
	CAIRO_LCD_FILTER_DEFAULT,
	CAIRO_LCD_FILTER_NONE,
	CAIRO_LCD_FILTER_INTRA_PIXEL,
	CAIRO_LCD_FILTER_FIR3,
	CAIRO_LCD_FILTER_FIR5
}; typedef cairo_enum_t cairo_lcd_filter_t;

typedef enum _cairo_round_glyph_pos {
	CAIRO_ROUND_GLYPH_POS_DEFAULT,
	CAIRO_ROUND_GLYPH_POS_ON,
	CAIRO_ROUND_GLYPH_POS_OFF
}; typedef cairo_enum_t cairo_round_glyph_positions_t;

void                          _cairo_font_options_set_lcd_filter            (cairo_font_options_t *options, cairo_lcd_filter_t lcd_filter);
cairo_lcd_filter_t            _cairo_font_options_get_lcd_filter            (const cairo_font_options_t *options);
void                          _cairo_font_options_set_round_glyph_positions (cairo_font_options_t *options, cairo_round_glyph_positions_t round);
cairo_round_glyph_positions_t _cairo_font_options_get_round_glyph_positions (const cairo_font_options_t *options);


// cairo-ft.h
typedef struct FT_FaceRec_* FT_Face;

typedef enum {
    CAIRO_FT_SYNTHESIZE_BOLD = 1 << 0,
    CAIRO_FT_SYNTHESIZE_OBLIQUE = 1 << 1
}; typedef cairo_enum_t cairo_ft_synthesize_t;

cairo_font_face_t * cairo_ft_font_face_create_for_ft_face (FT_Face face, int load_flags);
void                cairo_ft_font_face_set_synthesize     (cairo_font_face_t *font_face, unsigned int synth_flags);
void                cairo_ft_font_face_unset_synthesize   (cairo_font_face_t *font_face, unsigned int synth_flags);
unsigned int        cairo_ft_font_face_get_synthesize     (cairo_font_face_t *font_face);

FT_Face             cairo_ft_scaled_font_lock_face   (cairo_scaled_font_t *scaled_font);
void                cairo_ft_scaled_font_unlock_face (cairo_scaled_font_t *scaled_font);

// cairo-pdf.h

typedef enum _cairo_pdf_version {
	CAIRO_PDF_VERSION_1_4,
	CAIRO_PDF_VERSION_1_5
}; typedef cairo_enum_t cairo_pdf_version_t;

cairo_surface_t * cairo_pdf_surface_create              (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t * cairo_pdf_surface_create_for_stream   (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);
void              cairo_pdf_surface_restrict_to_version (cairo_surface_t *surface, cairo_pdf_version_t version);
void              cairo_pdf_get_versions                (cairo_pdf_version_t const **versions, int *num_versions);
const char *      cairo_pdf_version_to_string           (cairo_pdf_version_t version);
void              cairo_pdf_surface_set_size            (cairo_surface_t *surface, double width_in_points, double height_in_points);

// cairo-ps.h

typedef enum _cairo_ps_level {
    CAIRO_PS_LEVEL_2,
    CAIRO_PS_LEVEL_3
}; typedef cairo_enum_t cairo_ps_level_t;

cairo_surface_t * cairo_ps_surface_create               (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t * cairo_ps_surface_create_for_stream    (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);
void              cairo_ps_surface_restrict_to_level    (cairo_surface_t *surface, cairo_ps_level_t level);
void              cairo_ps_get_levels                   (cairo_ps_level_t const **levels, int *num_levels);
const char *      cairo_ps_level_to_string              (cairo_ps_level_t level);
void              cairo_ps_surface_set_eps              (cairo_surface_t *surface, cairo_bool_t eps);
cairo_bool_t      cairo_ps_surface_get_eps              (cairo_surface_t *surface);
void              cairo_ps_surface_set_size             (cairo_surface_t *surface, double width_in_points, double height_in_points);
void              cairo_ps_surface_dsc_comment          (cairo_surface_t *surface, const char *comment);
void              cairo_ps_surface_dsc_begin_setup      (cairo_surface_t *surface);
void              cairo_ps_surface_dsc_begin_page_setup (cairo_surface_t *surface);

// cairo-svg.h

typedef enum _cairo_svg_version {
	CAIRO_SVG_VERSION_1_1,
	CAIRO_SVG_VERSION_1_2
}; typedef cairo_enum_t cairo_svg_version_t;

cairo_surface_t * cairo_svg_surface_create              (const char *filename, double width_in_points, double height_in_points);
cairo_surface_t * cairo_svg_surface_create_for_stream   (cairo_write_func_t write_func, void *closure, double width_in_points, double height_in_points);
void              cairo_svg_surface_restrict_to_version (cairo_surface_t *surface, cairo_svg_version_t version);
void              cairo_svg_get_versions                (cairo_svg_version_t const **versions, int *num_versions);
const             char * cairo_svg_version_to_string    (cairo_svg_version_t version);
]])

--cairo graphics library ffi binding.
--Written by Cosmin Apreutesei. Public Domain.

--Supports garbage collection, metatype methods, accepting and returning
--strings, returning multiple values instead of passing output buffers,
--and many API additions for completeness.

local ffi = require("ffi")
local bit = require("bit")
local function _load_cairo_lib()
  local ok, res = pcall(ffi.load, "cairo")
  if ok then
    return res
  end
  if ffi.os == "OSX" then
    local ok, res = pcall(ffi.load, "/opt/homebrew/lib/libcairo.dylib")
    if ok then
      return res
    end
  end
  error("could not load cairo library")
end
local C = _load_cairo_lib()
local M = { C = C }

--binding vocabulary ---------------------------------------------------------

--C namespace that returns nil for missing symbols instead of raising an error.
local function sym(name)
  return C[name]
end
local _C = setmetatable({}, {
  __index = function(_C, k)
    return pcall(sym, k) and C[k] or nil
  end,
})
M._C = _C

--bidirectional mapper for enum values to names
local enums = {} --{prefix -> {enumval -> name; name -> enumval}}
local function map(prefix, t)
  local dt = {}
  for i, v in ipairs(t) do
    local k = C[prefix .. tostring(v)]
    local v = type(v) == "string" and v:lower() or v
    dt[k] = v
    dt[v] = k
  end
  enums[prefix] = dt
end
M.enums = enums

--'foo' -> C.CAIRO_<PREFIX>_FOO and C.CAIRO_<PREFIX>_FOO -> 'foo' conversions
local function convert_prefix(prefix, val)
  local value = enums[prefix][val]
  if not value then
    error("invalid enum value for " .. prefix, 2)
  end
  return value
end

--create a gc-tying constructor
local function ref_func(create, destroy)
  return create
    and function(...)
      local self = create(...)
      return self ~= nil and ffi.gc(self, destroy) or nil
    end
end

--method for freeing reference-counted objects: crash if there are still references.
local function free(self)
  local n = self:refcount() - 1
  self:unref()
  if n ~= 0 then
    error(string.format("refcount of %s is %d, should be 0", tostring(self), n))
  end
end

--create a gc-untying destructor
local function destroy_func(destroy)
  return function(self)
    ffi.gc(self, nil)
    destroy(self)
  end
end

--create a flag setter
local function setflag_func(set, prefix)
  return set
    and function(self, flag)
      set(self, convert_prefix(prefix, flag))
    end
end

--create a flag getter
local function getflag_func(get, prefix)
  return get
    and function(self)
      return convert_prefix(prefix, get(self))
    end
end

--create a get/set function that disambiguates get() from set() actions
--by the second argument being nil or not.
local function getset_func(get, set, prefix)
  if not (get and set) then
    return
  end
  if prefix then
    get = getflag_func(get, prefix)
    set = setflag_func(set, prefix)
  end
  return function(self, ...)
    if type((...)) == "nil" then --get val
      return get(self, ...)
    else --set val
      set(self, ...)
      return self --for method chaining
    end
  end
end

--scratch out-vars
local d1 = ffi.new("double[1]")
local d2 = ffi.new("double[1]")
local d3 = ffi.new("double[1]")
local d4 = ffi.new("double[1]")
local d5 = ffi.new("double[1]")
local d6 = ffi.new("double[1]")

--wrap a function that takes two output doubles
local function d2out_func(func)
  return func
    and function(self)
      func(self, d1, d2)
      return { d1[0], d2[0] }
    end
end

--wrap a function that takes two in-out doubles
local function d2inout_func(func)
  return func
    and function(self, x, y)
      d1[0], d2[0] = x, y
      func(self, d1, d2)
      return { d1[0], d2[0] }
    end
end

--wrap a function that takes 4 output doubles
local function d4out_func(func)
  return func
    and function(self)
      func(self, d1, d2, d3, d4)
      return { d1[0], d2[0], d3[0], d4[0] }
    end
end

-- wrap a function that returns a boolean
local function bool_func(f)
  return f and function(...)
    return f(...) == 1
  end
end

--factory for creating wrappers for functions that have a struct output arg
local function structout_func(ctype)
  ctype = ffi.typeof(ctype)
  return function(func)
    return func
      and function(self, out)
        out = out or ctype()
        func(self, out)
        return out
      end
  end
end
local mtout_func = structout_func("cairo_matrix_t")

--factory for creating wrappers for functions that have a constructed output arg
local function consout_func(cons)
  return function(func)
    return func
      and function(self, out)
        out = out or cons()
        func(self, out)
        return out
      end
  end
end
local foptout_func = consout_func(
  ref_func(C.cairo_font_options_create, C.cairo_font_options_destroy)
)

--wrap a function that has a cairo_text_extents_t as output arg 2 after self
local function texout2_func(func)
  local ctype = ffi.typeof("cairo_text_extents_t")
  return func
    and function(self, arg1, out)
      out = out or ctype()
      func(self, arg1, out)
      return out
    end
end

--wrap a function that has a cairo_text_extents_t as output arg 3 after self
local function texout3_func(func)
  local ctype = ffi.typeof("cairo_text_extents_t")
  return func
    and function(self, arg1, arg2, out)
      out = out or ctype()
      func(self, arg1, arg2, out)
      return out
    end
end

--wrap a function that has a cairo_font_extents_t as output arg 1 after self
local function fexout_func(func)
  local ctype = ffi.typeof("cairo_font_extents_t")
  return func
    and function(self, out)
      out = out or ctype()
      func(self, out)
      return out
    end
end

--wrap a function that returns a string
local function str_func(func)
  return func and function(...)
    return ffi.string(func(...))
  end
end

--convert a function with an output arg into a getter to be used with getset_func.
--all we're doing is shifting the out arg from arg#1 to arg#2 after self so that
--disambiguation between get and set actions can continue to work yet we can still
--be able to give an output buffer in arg#2 for the get action.
local function getter_func(out_func)
  return function(func)
    local func = out_func(func)
    return function(self, _, out)
      return func(self, out)
    end
  end
end
local mtout_getfunc = getter_func(mtout_func)
local foptout_getfunc = getter_func(foptout_func)

local function check_status(status)
  if status ~= 0 then
    error(M.status_message(status), 2)
  end
end

local function ret_status(st)
  if st == 0 then
    return true
  else
    return nil, M.status_message(st), st
  end
end
local function status_func(func)
  return function(...)
    return ret_status(func(...))
  end
end

local function ptr(p) --convert NULL to nil
  if p == nil then
    return nil
  end
  return p
end

--wrap a pointer-returning function so that NULL is converted to nil
local function ptr_func(func)
  return func and function(...)
    return ptr(func(...))
  end
end

--method to get status as a string, for any object which has a status() method.
local function status_message(self)
  return M.status_message(self:status())
end

--method to check the status and raise and error
local function check(self)
  local status = self:status()
  if status ~= 0 then
    error(self:status_message(), 2)
  end
end

local ir = ffi.new("cairo_rectangle_int_t")
local function set_int_rect(x, y, w, h)
  if not x then
    return
  end
  ir.x = x
  ir.y = y
  ir.width = w
  ir.height = h
  return ir
end

local sr_ct = ffi.typeof("cairo_surface_t*")
local function patt_or_surface_func(patt_func, surface_func)
  return function(self, patt, x, y)
    if ffi.istype(patt, sr_ct) then
      surface_func(self, patt, x or 0, y or 0)
    else
      patt_func(self, patt)
    end
  end
end

local function unpack_rect(r)
  return r.x, r.y, r.width, r.height
end

local function ret_self(func)
  return function(self, ...)
    func(self, ...)
    return self
  end
end

--binding --------------------------------------------------------------------

M.NULL = ffi.cast("void*", 0)

M.version = C.cairo_version
M.version_string = str_func(C.cairo_version_string)

map("CAIRO_STATUS_", {
  "SUCCESS",
  "NO_MEMORY",
  "INVALID_RESTORE",
  "INVALID_POP_GROUP",
  "NO_CURRENT_POINT",
  "INVALID_MATRIX",
  "INVALID_STATUS",
  "NULL_POINTER",
  "INVALID_STRING",
  "INVALID_PATH_DATA",
  "READ_ERROR",
  "WRITE_ERROR",
  "SURFACE_FINISHED",
  "SURFACE_TYPE_MISMATCH",
  "PATTERN_TYPE_MISMATCH",
  "INVALID_CONTENT",
  "INVALID_FORMAT",
  "INVALID_VISUAL",
  "FILE_NOT_FOUND",
  "INVALID_DASH",
  "INVALID_DSC_COMMENT",
  "INVALID_INDEX",
  "CLIP_NOT_REPRESENTABLE",
  "TEMP_FILE_ERROR",
  "INVALID_STRIDE",
  "FONT_TYPE_MISMATCH",
  "USER_FONT_IMMUTABLE",
  "USER_FONT_ERROR",
  "NEGATIVE_COUNT",
  "INVALID_CLUSTERS",
  "INVALID_SLANT",
  "INVALID_WEIGHT",
  "INVALID_SIZE",
  "USER_FONT_NOT_IMPLEMENTED",
  "DEVICE_TYPE_MISMATCH",
  "DEVICE_ERROR",
  "INVALID_MESH_CONSTRUCTION",
  "DEVICE_FINISHED",
  "LAST_STATUS",
})

map("CAIRO_CONTENT_", {
  "COLOR",
  "ALPHA",
  "COLOR_ALPHA",
})

map("CAIRO_FORMAT_", {
  "INVALID",
  "ARGB32",
  "RGB24",
  "A8",
  "A1",
  "RGB16_565",
  "RGB30",
})

local cairo_formats = {
  bgra8 = "argb32",
  bgrx8 = "rgb24",
  g8 = "a8",
  g1 = "a1",
  rgb565 = "rgb16_565",
  bgr10 = "rgb30",
}

local bitmap_formats = {
  argb32 = "bgra8",
  rgb24 = "bgrx8",
  a8 = "g8",
  a1 = "g1",
  rgb16_565 = "rgb565",
  rgb30 = "bgr10",
  invalid = "invalid",
}

function M.cairo_format(format)
  return cairo_formats[format] or format
end

function M.bitmap_format(format)
  return bitmap_formats[format] or format
end

local cr = {}

cr.status = C.cairo_status
cr.status_message = status_message
cr.check = check

cr.ref = ref_func(C.cairo_reference, C.cairo_destroy)
cr.unref = destroy_func(C.cairo_destroy)
cr.free = free
cr.refcount = C.cairo_get_reference_count

cr.save = C.cairo_save
cr.restore = C.cairo_restore

local push_group_with_content =
  setflag_func(C.cairo_push_group_with_content, "CAIRO_CONTENT_")
cr.push_group = function(cr, content)
  if content then
    push_group_with_content(cr, content)
  else
    C.cairo_push_group(cr)
  end
end
cr.pop_group = ref_func(C.cairo_pop_group, C.cairo_pattern_destroy)
cr.pop_group_to_source = C.cairo_pop_group_to_source

map("CAIRO_OPERATOR_", {
  "CLEAR",
  "SOURCE",
  "OVER",
  "IN",
  "OUT",
  "ATOP",
  "DEST",
  "DEST_OVER",
  "DEST_IN",
  "DEST_OUT",
  "DEST_ATOP",
  "XOR",
  "ADD",
  "SATURATE",
  "MULTIPLY",
  "SCREEN",
  "OVERLAY",
  "DARKEN",
  "LIGHTEN",
  "COLOR_DODGE",
  "COLOR_BURN",
  "HARD_LIGHT",
  "SOFT_LIGHT",
  "DIFFERENCE",
  "EXCLUSION",
  "HSL_HUE",
  "HSL_SATURATION",
  "HSL_COLOR",
  "HSL_LUMINOSITY",
})

cr.operator =
  getset_func(C.cairo_get_operator, C.cairo_set_operator, "CAIRO_OPERATOR_")
cr.source = getset_func(
  C.cairo_get_source,
  patt_or_surface_func(C.cairo_set_source, C.cairo_set_source_surface)
)
cr.rgb = C.cairo_set_source_rgb
cr.rgba = C.cairo_set_source_rgba
cr.tolerance = getset_func(C.cairo_get_tolerance, C.cairo_set_tolerance)

map("CAIRO_ANTIALIAS_", {
  "DEFAULT",
  "NONE",
  "GRAY",
  "SUBPIXEL",
  "FAST",
  "GOOD",
  "BEST",
})

cr.antialias =
  getset_func(C.cairo_get_antialias, C.cairo_set_antialias, "CAIRO_ANTIALIAS_")

map("CAIRO_FILL_RULE_", {
  "WINDING",
  "EVEN_ODD",
})

cr.fill_rule =
  getset_func(C.cairo_get_fill_rule, C.cairo_set_fill_rule, "CAIRO_FILL_RULE_")

cr.line_width = getset_func(C.cairo_get_line_width, C.cairo_set_line_width)

map("CAIRO_LINE_CAP_", {
  "BUTT",
  "ROUND",
  "SQUARE",
})

cr.line_cap =
  getset_func(C.cairo_get_line_cap, C.cairo_set_line_cap, "CAIRO_LINE_CAP_")

map("CAIRO_LINE_JOIN_", {
  "MITER",
  "ROUND",
  "BEVEL",
})

cr.line_join =
  getset_func(C.cairo_get_line_join, C.cairo_set_line_join, "CAIRO_LINE_JOIN_")

cr.dash = function(cr, dashes, num_dashes, offset)
  if dashes == "#" then --dash(cr, '#') -> get count
    return C.cairo_get_dash_count(cr)
  elseif dashes == nil then
    if num_dashes then --dash(cr, nil, double*) -> get into array
      dashes = num_dashes
      C.cairo_get_dash(cr, dashes, d1)
      return dashes, d1[0]
    else --dash(cr) -> get into table
      local n = C.cairo_get_dash_count(cr)
      dashes = ffi.new("double[?]", n)
      C.cairo_get_dash(cr, dashes, d1)
      local t = {}
      for i = 1, n do
        t[i] = dashes[i - 1]
      end
      return t, d1[0]
    end
  elseif type(dashes) == "table" then --dash(cr, t[, offset]) -> set from table
    num_dashes, offset = #dashes, num_dashes
    dashes = ffi.new("double[?]", num_dashes, dashes)
    C.cairo_set_dash(cr, dashes, num_dashes, offset or 0)
  else --dash(cr, dashes*, num_dashes[, offset]) -> set from array
    if dashes == false then --for when num_dashes == 0
      dashes = nil
      assert(num_dashes == 0)
    end
    C.cairo_set_dash(cr, dashes, num_dashes, offset or 0)
  end
end

cr.miter_limit = getset_func(C.cairo_get_miter_limit, C.cairo_set_miter_limit)

cr.translate = ret_self(C.cairo_translate)
cr.scale = function(cr, sx, sy)
  C.cairo_scale(cr, sx, sy or sx)
  return cr
end
cr.rotate = ret_self(C.cairo_rotate)
cr.transform = ret_self(C.cairo_transform)

cr.get_matrix = mtout_getfunc(C.cairo_get_matrix)
cr.set_matrix = C.cairo_set_matrix
cr.identity_matrix = ret_self(C.cairo_identity_matrix)

cr.user_to_device = d2inout_func(C.cairo_user_to_device)
cr.user_to_device_distance = d2inout_func(C.cairo_user_to_device_distance)
cr.device_to_user = d2inout_func(C.cairo_device_to_user)
cr.device_to_user_distance = d2inout_func(C.cairo_device_to_user_distance)

cr.new_path = C.cairo_new_path
cr.move_to = C.cairo_move_to
cr.new_sub_path = C.cairo_new_sub_path
cr.line_to = C.cairo_line_to
cr.curve_to = C.cairo_curve_to
cr.arc = C.cairo_arc
cr.arc_negative = C.cairo_arc_negative
cr.rel_move_to = C.cairo_rel_move_to
cr.rel_line_to = C.cairo_rel_line_to
cr.rel_curve_to = C.cairo_rel_curve_to
cr.rectangle = C.cairo_rectangle
cr.close_path = C.cairo_close_path
cr.path_extents = d4out_func(C.cairo_path_extents)
cr.paint = C.cairo_paint
cr.paint_with_alpha = C.cairo_paint_with_alpha
cr.mask = C.cairo_mask
cr.mask_surface = C.cairo_mask_surface
cr.stroke = C.cairo_stroke
cr.stroke_preserve = C.cairo_stroke_preserve
cr.fill = C.cairo_fill
cr.fill_preserve = C.cairo_fill_preserve

cr.copy_page = C.cairo_copy_page
cr.show_page = C.cairo_show_page

cr.in_stroke = bool_func(C.cairo_in_stroke)
cr.in_fill = bool_func(C.cairo_in_fill)
cr.in_clip = bool_func(C.cairo_in_clip)

cr.stroke_extents = d4out_func(C.cairo_stroke_extents)
cr.fill_extents = d4out_func(C.cairo_fill_extents)
cr.reset_clip = C.cairo_reset_clip
cr.clip = C.cairo_clip
cr.clip_preserve = C.cairo_clip_preserve
cr.clip_extents = d4out_func(C.cairo_clip_extents)
cr.clip_rectangles =
  ref_func(C.cairo_copy_clip_rectangle_list, C.cairo_rectangle_list_destroy)

local rl = {}

rl.free = destroy_func(C.cairo_rectangle_list_destroy)

M.allocate_glyphs = ref_func(C.cairo_glyph_allocate, C.cairo_glyph_free)

local glyph = {}

glyph.free = destroy_func(C.cairo_glyph_free)

M.allocate_text_clusters =
  ref_func(C.cairo_text_cluster_allocate, C.cairo_text_cluster_free)

local cluster = {}

cluster.free = destroy_func(C.cairo_text_cluster_free)

map("CAIRO_TEXT_CLUSTER_FLAG_", {
  "BACKWARD",
})

map("CAIRO_FONT_SLANT_", {
  "NORMAL",
  "ITALIC",
  "OBLIQUE",
})

map("CAIRO_FONT_WEIGHT_", {
  "NORMAL",
  "BOLD",
})

map("CAIRO_SUBPIXEL_ORDER_", {
  "DEFAULT",
  "RGB",
  "BGR",
  "VRGB",
  "VBGR",
})

map("CAIRO_HINT_STYLE_", {
  "DEFAULT",
  "NONE",
  "SLIGHT",
  "MEDIUM",
  "FULL",
})

map("CAIRO_HINT_METRICS_", {
  "DEFAULT",
  "OFF",
  "ON",
})

M.font_options =
  ref_func(C.cairo_font_options_create, C.cairo_font_options_destroy)

local fopt = {}

fopt.copy = ref_func(C.cairo_font_options_copy, C.cairo_font_options_destroy)
fopt.free = destroy_func(C.cairo_font_options_destroy)
fopt.status = C.cairo_font_options_status
fopt.status_message = status_message
fopt.check = check
fopt.merge = C.cairo_font_options_merge
fopt.equal = bool_func(C.cairo_font_options_equal)
fopt.hash = C.cairo_font_options_hash
fopt.antialias = getset_func(
  C.cairo_font_options_get_antialias,
  C.cairo_font_options_set_antialias,
  "CAIRO_ANTIALIAS_"
)
fopt.subpixel_order = getset_func(
  C.cairo_font_options_get_subpixel_order,
  C.cairo_font_options_set_subpixel_order,
  "CAIRO_SUBPIXEL_ORDER_"
)
fopt.hint_style = getset_func(
  C.cairo_font_options_get_hint_style,
  C.cairo_font_options_set_hint_style,
  "CAIRO_HINT_STYLE_"
)
fopt.hint_metrics = getset_func(
  C.cairo_font_options_get_hint_metrics,
  C.cairo_font_options_set_hint_metrics,
  "CAIRO_HINT_METRICS_"
)

cr.font_size = C.cairo_set_font_size
cr.font_matrix =
  getset_func(mtout_getfunc(C.cairo_get_font_matrix), C.cairo_set_font_matrix)
cr.font_options = getset_func(
  foptout_getfunc(C.cairo_get_font_options),
  C.cairo_set_font_options
)
cr.font_face = getset_func(
  C.cairo_get_font_face,
  function(cr, family, slant, weight)
    if type(family) == "string" then
      C.cairo_select_font_face(
        cr,
        family,
        convert_prefix("CAIRO_FONT_SLANT_", slant or "normal"),
        convert_prefix("CAIRO_FONT_WEIGHT_", weight or "normal")
      )
    else
      C.cairo_set_font_face(cr, family) --in fact: cairo_font_face_t
    end
  end
)
cr.scaled_font = getset_func(C.cairo_get_scaled_font, C.cairo_set_scaled_font) --weak ref
cr.show_text = C.cairo_show_text
cr.show_glyphs = C.cairo_show_glyphs
cr.show_text_glyphs = function(
  cr,
  s,
  slen,
  glyphs,
  num_glyphs,
  clusters,
  num_clusters,
  cluster_flags
)
  C.cairo_show_text_glyphs(
    cr,
    s,
    slen or #s,
    glyphs,
    num_glyphs,
    clusters,
    num_clusters,
    cluster_flags and convert_prefix("CAIRO_TEXT_CLUSTER_FLAG_", cluster_flags)
      or 0
  )
end
cr.text_path = C.cairo_text_path
cr.glyph_path = C.cairo_glyph_path
cr.text_extents = texout2_func(C.cairo_text_extents)
cr.glyph_extents = texout3_func(C.cairo_glyph_extents)
cr.font_extents = fexout_func(C.cairo_font_extents)

local face = {}

face.ref = ref_func(C.cairo_font_face_reference)
face.unref = destroy_func(C.cairo_font_face_destroy)
face.free = free
face.refcount = C.cairo_font_face_get_reference_count
face.status = C.cairo_font_face_status
face.status_message = status_message
face.check = check

map("CAIRO_FONT_TYPE_", {
  "TOY",
  "FT",
  "WIN32",
  "QUARTZ",
  "USER",
})

face.type = getflag_func(C.cairo_font_face_get_type, "CAIRO_FONT_TYPE_")
face.scaled_font = ref_func(function(face, mt, ctm, fopt)
  --cairo crashes if any of these is null
  assert(mt ~= nil)
  assert(ctm ~= nil)
  assert(fopt ~= nil)
  return C.cairo_scaled_font_create(face, mt, ctm, fopt)
end, C.cairo_scaled_font_destroy)

local sfont = {}

sfont.ref = ref_func(C.cairo_scaled_font_reference, C.cairo_scaled_font_destroy)
sfont.unref = destroy_func(C.cairo_scaled_font_destroy)
sfont.free = free
sfont.refcount = C.cairo_scaled_font_get_reference_count
sfont.status = C.cairo_scaled_font_status
sfont.status_message = status_message
sfont.check = check
sfont.type = getflag_func(C.cairo_scaled_font_get_type, "CAIRO_FONT_TYPE_")
sfont.extents = fexout_func(C.cairo_scaled_font_extents)
sfont.text_extents = texout2_func(C.cairo_scaled_font_text_extents)
sfont.glyph_extents = texout3_func(C.cairo_scaled_font_glyph_extents)

local glyphs_buf = ffi.new("cairo_glyph_t*[1]")
local num_glyphs_buf = ffi.new("int[1]")
local clusters_buf = ffi.new("cairo_text_cluster_t*[1]")
local num_clusters_buf = ffi.new("int[1]")
local cluster_flags_buf = ffi.new("cairo_text_cluster_flags_t[1]")

function sfont.text_to_glyphs(
  sfont,
  x,
  y,
  s,
  slen,
  glyphs,
  num_glyphs,
  clusters,
  num_clusters
)
  glyphs_buf[0] = glyphs --optional: if nil, cairo allocates it
  num_glyphs_buf[0] = num_glyphs or 0
  clusters_buf[0] = clusters --optional: if nil, cairo allocates it
  num_clusters_buf[0] = num_clusters or 0
  local status = C.cairo_scaled_font_text_to_glyphs(
    sfont,
    x,
    y,
    s,
    slen or #s,
    glyphs_buf,
    num_glyphs_buf,
    clusters_buf,
    num_clusters_buf,
    cluster_flags_buf
  )
  if status == 0 then
    local glyphs = glyphs or ffi.gc(glyphs_buf[0], C.cairo_glyph_free)
    local clusters = clusters
      or ffi.gc(clusters_buf[0], C.cairo_text_cluster_free)
    return glyphs,
      num_glyphs_buf[0],
      clusters,
      num_clusters_buf[0],
      cluster_flags_buf[0] ~= 0 and convert_prefix(
        "CAIRO_TEXT_CLUSTER_FLAG_",
        tonumber(cluster_flags_buf[0])
      ) or nil
  else
    return nil, M.status_message(status), status
  end
end

sfont.font_face = C.cairo_scaled_font_get_font_face --weak ref
sfont.font_matrix = mtout_func(C.cairo_scaled_font_get_font_matrix)
sfont.ctm = mtout_func(C.cairo_scaled_font_get_ctm)
sfont.scale_matrix = mtout_func(C.cairo_scaled_font_get_scale_matrix)
sfont.font_options = foptout_func(C.cairo_scaled_font_get_font_options)

function M.toy_font_face(family, slant, weight)
  return ffi.gc(
    C.cairo_toy_font_face_create(
      family,
      convert_prefix("CAIRO_FONT_SLANT_", slant),
      convert_prefix("CAIRO_FONT_WEIGHT_", weight)
    ),
    C.cairo_font_face_destroy
  )
end

face.family = str_func(C.cairo_toy_font_face_get_family)
face.slant = getflag_func(C.cairo_toy_font_face_get_slant, "CAIRO_FONT_SLANT_")
face.weight =
  getflag_func(C.cairo_toy_font_face_get_weight, "CAIRO_FONT_WEIGHT_")

M.user_font_face =
  ref_func(C.cairo_user_font_face_create, C.cairo_font_face_destroy)

face.init_func = getset_func(
  C.cairo_user_font_face_get_init_func,
  C.cairo_user_font_face_set_init_func
)

face.render_glyph_func = getset_func(
  C.cairo_user_font_face_get_render_glyph_func,
  C.cairo_user_font_face_set_render_glyph_func
)

face.text_to_glyphs_func = getset_func(
  C.cairo_user_font_face_get_text_to_glyphs_func,
  C.cairo_user_font_face_set_text_to_glyphs_func
)

face.unicode_to_glyph_func = getset_func(
  C.cairo_user_font_face_get_unicode_to_glyph_func,
  C.cairo_user_font_face_set_unicode_to_glyph_func
)

cr.has_current_point = bool_func(C.cairo_has_current_point)
cr.current_point = d2out_func(C.cairo_get_current_point)
cr.target = C.cairo_get_target --weak ref
cr.group_target = C.cairo_get_group_target --weak ref

map("CAIRO_PATH_", {
  "MOVE_TO",
  "LINE_TO",
  "CURVE_TO",
  "CLOSE_PATH",
})

cr.copy_path = ref_func(C.cairo_copy_path, C.cairo_path_destroy)
cr.copy_path_flat = ref_func(C.cairo_copy_path, C.cairo_path_destroy)
cr.append_path = C.cairo_append_path

local path = {}

path.free = destroy_func(C.cairo_path_destroy)

local path_node_types = {
  [C.CAIRO_PATH_MOVE_TO] = "move_to",
  [C.CAIRO_PATH_LINE_TO] = "line_to",
  [C.CAIRO_PATH_CURVE_TO] = "curve_to",
  [C.CAIRO_PATH_CLOSE_PATH] = "close_path",
}

function path.dump(p)
  print(
    string.format(
      "cairo_path_t (length = %d, status = %s)",
      p.num_data,
      M.status_message(p.status)
    )
  )
  local i = 0
  while i < p.num_data do
    local d = p.data[i]
    print("", path_node_types[tonumber(d.header.type)])
    i = i + 1
    for j = 1, d.header.length - 1 do
      local d = p.data[i]
      print("", "", string.format("%g, %g", d.point.x, d.point.y))
      i = i + 1
    end
  end
end

function path.equal(p1, p2)
  if not ffi.istype("cairo_path_t", p2) then
    return false
  end
  if p1.num_data ~= p2.num_data then
    return false
  end
  for i = 0, p1.num_data - 1 do
    if p1.data[i].e1 ~= p2.data[i].e1 or p1.data[i].e2 ~= p2.data[i].e2 then
      return false
    end
  end
end

M.status_message = str_func(C.cairo_status_to_string)

local dev = {}

dev.ref = ref_func(C.cairo_device_reference, C.cairo_device_destroy)

map("CAIRO_DEVICE_TYPE_", {
  "DRM",
  "GL",
  "SCRIPT",
  "XCB",
  "XLIB",
  "XML",
  "COGL",
  "WIN32",
  "INVALID",
})

dev.type = getflag_func(C.cairo_device_get_type, "CAIRO_DEVICE_TYPE_")
dev.status = C.cairo_device_status
dev.status_message = status_message
dev.check = check
dev.acquire = status_func(C.cairo_device_acquire)
dev.release = C.cairo_device_release
dev.flush = C.cairo_device_flush
dev.finish = C.cairo_device_finish
dev.unref = destroy_func(C.cairo_device_destroy)
dev.free = free
dev.refcount = C.cairo_device_get_reference_count

local sr = {}

sr.context = ref_func(C.cairo_create, C.cairo_destroy)

sr.similar_surface = ref_func(function(sr, content, w, h)
  return C.cairo_surface_create_similar(
    sr,
    convert_prefix("CAIRO_CONTENT_", content),
    w,
    h
  )
end, C.cairo_surface_destroy)

sr.similar_image_surface = ref_func(function(sr, fmt, w, h)
  local fmt = M.cairo_format(fmt)
  return C.cairo_surface_create_similar_image(
    sr,
    convert_prefix("CAIRO_FORMAT_", fmt),
    w,
    h
  )
end, C.cairo_surface_destroy)

sr.map_to_image = function(sr, x, y, w, h)
  local isr = C.cairo_surface_map_to_image(sr, set_int_rect(x, y, w, h))
  return ffi.gc(isr, function(isr)
    C.cairo_surface_unmap_image(sr, isr)
  end)
end

sr.unmap_image = function(sr, isr)
  ffi.gc(isr, nil)
  C.cairo_surface_unmap_image(sr, isr)
end

sr.create_for_rectangle =
  ref_func(C.cairo_surface_create_for_rectangle, C.cairo_surface_destroy)

map("CAIRO_SURFACE_OBSERVER_", {
  "NORMAL",
  "RECORD_OPERATIONS",
})

sr.observer_surface = function(sr, mode)
  local osr = C.cairo_surface_create_observer(
    sr,
    convert_prefix("CAIRO_SURFACE_OBSERVER_", mode)
  )
  return ffi.gc(osr, C.cairo_surface_destroy)
end

sr.add_paint_callback = C.cairo_surface_observer_add_paint_callback
sr.add_mask_callback = C.cairo_surface_observer_add_mask_callback
sr.add_fill_callback = C.cairo_surface_observer_add_fill_callback
sr.add_stroke_callback = C.cairo_surface_observer_add_stroke_callback
sr.add_glyphs_callback = C.cairo_surface_observer_add_glyphs_callback
sr.add_flush_callback = C.cairo_surface_observer_add_flush_callback
sr.add_finish_callback = C.cairo_surface_observer_add_finish_callback
sr.print = C.cairo_surface_observer_print
sr.elapsed = C.cairo_surface_observer_elapsed

dev.print = C.cairo_device_observer_print
dev.elapsed = C.cairo_device_observer_elapsed
dev.paint_elapsed = C.cairo_device_observer_paint_elapsed
dev.mask_elapsed = C.cairo_device_observer_mask_elapsed
dev.fill_elapsed = C.cairo_device_observer_fill_elapsed
dev.stroke_elapsed = C.cairo_device_observer_stroke_elapsed
dev.glyphs_elapsed = C.cairo_device_observer_glyphs_elapsed

sr.ref = ref_func(C.cairo_surface_reference, C.cairo_surface_destroy)
sr.finish = C.cairo_surface_finish
sr.unref = destroy_func(C.cairo_surface_destroy)
sr.free = free

sr.device = ptr_func(C.cairo_surface_get_device) --weak ref
sr.refcount = C.cairo_surface_get_reference_count
sr.status = C.cairo_surface_status
sr.status_message = status_message
sr.check = check

map("CAIRO_SURFACE_TYPE_", {
  "IMAGE",
  "PDF",
  "PS",
  "XLIB",
  "XCB",
  "GLITZ",
  "QUARTZ",
  "WIN32",
  "BEOS",
  "DIRECTFB",
  "SVG",
  "OS2",
  "WIN32_PRINTING",
  "QUARTZ_IMAGE",
  "SCRIPT",
  "QT",
  "RECORDING",
  "VG",
  "GL",
  "DRM",
  "TEE",
  "XML",
  "SKIA",
  "SUBSURFACE",
  "COGL",
})

sr.type = getflag_func(C.cairo_surface_get_type, "CAIRO_SURFACE_TYPE_")
sr.content = getflag_func(C.cairo_surface_get_content, "CAIRO_CONTENT_")

sr.save_png = status_func(function(self, arg1, ...)
  if type(arg1) == "string" then
    return C.cairo_surface_write_to_png(self, arg1, ...)
  else
    return C.cairo_surface_write_to_png_stream(self, arg1, ...)
  end
end)

local data_buf = ffi.new("void*[1]")
local len_buf = ffi.new("unsigned long[1]")
sr.mime_data = function(sr, mime_type, data, len, destroy, closure)
  if data then
    return ret_status(
      C.cairo_surface_set_mime_data(sr, mime_type, data, len, destroy, closure)
    )
  else
    C.cairo_surface_get_mime_data(sr, mime_type, data_buf, len_buf)
    return data_buf[0], len_buf[0]
  end
end

sr.supports_mime_type = bool_func(C.cairo_surface_supports_mime_type)

sr.font_options = foptout_func(C.cairo_surface_get_font_options)
sr.flush = C.cairo_surface_flush

sr.mark_dirty = function(sr, x, y, w, h)
  if x then
    C.cairo_surface_mark_dirty_rectangle(sr, x, y, w, h)
  else
    C.cairo_surface_mark_dirty(sr)
  end
end

sr.device_offset = getset_func(
  d2out_func(C.cairo_surface_get_device_offset),
  C.cairo_surface_set_device_offset
)
sr.fallback_resolution = getset_func(
  d2out_func(C.cairo_surface_get_fallback_resolution),
  C.cairo_surface_set_fallback_resolution
)

sr.copy_page = C.cairo_surface_copy_page
sr.show_page = C.cairo_surface_show_page
sr.has_show_text_glyphs = bool_func(C.cairo_surface_has_show_text_glyphs)

M.image_surface = function(fmt, w, h)
  local fmt = M.cairo_format(fmt)
  return ffi.gc(
    C.cairo_image_surface_create(convert_prefix("CAIRO_FORMAT_", fmt), w, h),
    C.cairo_surface_destroy
  )
end

M.image_surface_from_data = function(fmt, data, w, h, stride)
  local format = convert_prefix("CAIRO_FORMAT_", M.cairo_format(fmt))
  local srf = C.cairo_image_surface_create_for_data(data, format, w, h, stride)
  return ffi.gc(srf, function(srf_)
    local _ = data --pin it
    C.cairo_surface_destroy(srf)
  end)
end

M.stride = function(fmt, width)
  local fmt = M.cairo_format(fmt)
  return C.cairo_format_stride_for_width(
    convert_prefix("CAIRO_FORMAT_", fmt),
    width
  )
end

sr.data = _C.cairo_image_surface_get_data
sr.format = getflag_func(_C.cairo_image_surface_get_format, "CAIRO_FORMAT_")
sr.width = _C.cairo_image_surface_get_width
sr.height = _C.cairo_image_surface_get_height
sr.stride = _C.cairo_image_surface_get_stride

M.load_png = ref_func(function(arg1, ...)
  if type(arg1) == "string" then
    return C.cairo_image_surface_create_from_png(arg1, ...)
  else
    return C.cairo_image_surface_create_from_png_stream(arg1, ...)
  end
end, C.cairo_surface_destroy)

local r = ffi.new("cairo_rectangle_t")
function M.recording_surface(content, x, y, w, h)
  if x then
    r.x = x
    r.y = y
    r.width = w
    r.height = h
  end
  return ffi.gc(
    C.cairo_recording_surface_create(
      convert_prefix("CAIRO_CONTENT_", content),
      x and r or nil
    ),
    C.cairo_surface_destroy
  )
end

sr.ink_extents = d4out_func(C.cairo_recording_surface_ink_extents)
sr.recording_extents = function(sr)
  if C.cairo_recording_surface_get_extents(sr, r) == 1 then
    return unpack_rect(r)
  end
end

M.raster_source_pattern = function(udata, content, w, h)
  local patt = C.cairo_pattern_create_raster_source(
    udata,
    convert_prefix("CAIRO_CONTENT_", content),
    w,
    h
  )
  return ffi.gc(patt, C.cairo_pattern_destroy)
end

local patt = {}

patt.callback_data = getset_func(
  C.cairo_raster_source_pattern_get_callback_data,
  C.cairo_raster_source_pattern_set_callback_data
)

local acquire_buf = ffi.new("cairo_raster_source_acquire_func_t[1]")
local release_buf = ffi.new("cairo_raster_source_release_func_t[1]")
patt.acquire_function = function(patt, acquire, release)
  if acquire then
    C.cairo_raster_source_pattern_set_acquire(patt, acquire, release)
  else
    C.cairo_raster_source_pattern_get_acquire(patt, acquire_buf, release_buf)
    return ptr(acquire_buf[0]), ptr(release_buf[0])
  end
end

patt.snapshot_function = getset_func(
  C.cairo_raster_source_pattern_get_snapshot,
  C.cairo_raster_source_pattern_set_snapshot
)

patt.copy_function = getset_func(
  C.cairo_raster_source_pattern_get_copy,
  C.cairo_raster_source_pattern_set_copy
)

patt.finish_function = getset_func(
  C.cairo_raster_source_pattern_get_finish,
  C.cairo_raster_source_pattern_set_finish
)

M.color_pattern = ref_func(function(r, g, b, a)
  return C.cairo_pattern_create_rgba(r, g, b, a or 1)
end, C.cairo_pattern_destroy)
M.surface_pattern =
  ref_func(C.cairo_pattern_create_for_surface, C.cairo_pattern_destroy)
M.linear_gradient =
  ref_func(C.cairo_pattern_create_linear, C.cairo_pattern_destroy)
M.radial_gradient =
  ref_func(C.cairo_pattern_create_radial, C.cairo_pattern_destroy)
M.mesh_pattern = ref_func(C.cairo_pattern_create_mesh, C.cairo_pattern_destroy)

patt.ref = ref_func(C.cairo_pattern_reference, C.cairo_pattern_destroy)
patt.unref = destroy_func(C.cairo_pattern_destroy)
patt.free = free
patt.refcount = C.cairo_pattern_get_reference_count
patt.status = C.cairo_pattern_status
patt.status_message = status_message
patt.check = check

map("CAIRO_PATTERN_TYPE_", {
  "SOLID",
  "SURFACE",
  "LINEAR",
  "RADIAL",
  "MESH",
  "RASTER_SOURCE",
})

patt.type = getflag_func(C.cairo_pattern_get_type, "CAIRO_PATTERN_TYPE_")

patt.add_color_stop = function(patt, offset, r, g, b, a)
  C.cairo_pattern_add_color_stop_rgba(patt, offset, r, g, b, a or 1)
end

patt.begin_patch = C.cairo_mesh_pattern_begin_patch
patt.end_patch = C.cairo_mesh_pattern_end_patch

patt.curve_to = C.cairo_mesh_pattern_curve_to
patt.line_to = C.cairo_mesh_pattern_line_to
patt.move_to = C.cairo_mesh_pattern_move_to

patt.control_point = function(patt, patch_num, point_num, x, y)
  if x then
    C.cairo_mesh_pattern_set_control_point(patt, patch_num, point_num, x) --in fact: patt, point_num, x, y
  else
    check_status(
      C.cairo_mesh_pattern_get_control_point(patt, patch_num, point_num, d1, d2)
    )
    return d1[0], d2[0]
  end
end

patt.corner_color = function(patt, patch_num, corner_num, r, g, b, a)
  if r then
    C.cairo_mesh_pattern_set_corner_color_rgba(
      patt,
      patch_num,
      corner_num,
      r,
      g,
      b or 1
    ) --in fact: patt, corner_num, r, g, b, a
  else
    check_status(
      C.cairo_mesh_pattern_get_corner_color_rgba(
        patt,
        patch_num,
        corner_num,
        d1,
        d2,
        d3,
        d4
      )
    )
    return d1[0], d2[0], d3[0], d4[0]
  end
end

patt.matrix = getset_func(
  mtout_getfunc(C.cairo_pattern_get_matrix),
  C.cairo_pattern_set_matrix
)

map("CAIRO_EXTEND_", {
  "NONE",
  "REPEAT",
  "REFLECT",
  "PAD",
})

patt.extend = getset_func(
  C.cairo_pattern_get_extend,
  C.cairo_pattern_set_extend,
  "CAIRO_EXTEND_"
)

map("CAIRO_FILTER_", {
  "FAST",
  "GOOD",
  "BEST",
  "NEAREST",
  "BILINEAR",
  "GAUSSIAN",
})

patt.filter = getset_func(
  C.cairo_pattern_get_filter,
  C.cairo_pattern_set_filter,
  "CAIRO_FILTER_"
)

patt.color = d4out_func(function(...)
  check_status(C.cairo_pattern_get_rgba(...))
end)

local sr_buf = ffi.new("cairo_surface_t*[1]")
patt.surface = function(patt)
  check_status(C.cairo_pattern_get_surface(patt, sr_buf))
  return ptr(sr_buf[0])
end

local c = ffi.new("int[1]")
patt.color_stop = function(patt, i)
  if i == "#" then
    check_status(C.cairo_pattern_get_color_stop_count(patt, c))
    return c[0]
  else
    check_status(
      C.cairo_pattern_get_color_stop_rgba(patt, i, d1, d2, d3, d4, d5)
    )
    return d1[0], d2[0], d3[0], d4[0], d5[0] --offset, r, g, b, a
  end
end

patt.linear_points = function(patt)
  check_status(C.cairo_pattern_get_linear_points(patt, d1, d1, d2, d2))
  return d1[0], d2[0], d3[0], d4[0]
end

patt.radial_circles = function(patt)
  check_status(C.cairo_pattern_get_radial_circles(patt, d1, d2, d3, d4, d5, d6))
  return d1[0], d2[0], d3[0], d4[0], d5[0], d6[0] --x1, y1, r1, x2, y2, r2
end

local c = ffi.new("unsigned int[1]")
patt.patch_count = function(patt)
  check_status(C.cairo_mesh_pattern_get_patch_count(patt, c))
  return tonumber(c[0])
end

patt.path = ptr_func(C.cairo_mesh_pattern_get_path) --weak ref? doc doesn't say

local mat_cons = ffi.typeof("cairo_matrix_t")
M.matrix = function(arg1, ...)
  if not arg1 then --default constructor
    return mat_cons(1, 0, 0, 1, 0, 0)
  end
  return mat_cons(arg1, ...) --copy and value constructors from ffi
end

local mt = {}

mt.reset = function(mt, arg1, ...)
  if not arg1 then --default constructor
    return mt:reset(1, 0, 0, 1, 0, 0)
  elseif type(arg1) == "number" then --value constructor
    C.cairo_matrix_init(mt, arg1, ...)
    return mt
  else --copy constructor
    ffi.copy(mt, arg1, ffi.sizeof(mt))
    return mt
  end
end
mt.translate = ret_self(C.cairo_matrix_translate)
mt.scale = function(mt, sx, sy)
  C.cairo_matrix_scale(mt, sx, sy or sx)
  return mt
end
mt.rotate = ret_self(C.cairo_matrix_rotate)
mt.invert = function(mt)
  check_status(C.cairo_matrix_invert(mt))
  return mt
end
mt.multiply = function(mt, mt1, mt2)
  if mt2 then
    C.cairo_matrix_multiply(mt, mt1, mt2)
  else
    C.cairo_matrix_multiply(mt, mt, mt1)
  end
  return mt
end
mt.distance = d2inout_func(C.cairo_matrix_transform_distance)
mt.point = d2inout_func(C.cairo_matrix_transform_point)

map("CAIRO_REGION_OVERLAP_", {
  "IN",
  "OUT",
  "PART",
})

M.region = ref_func(function(arg1, ...)
  if type(arg1) == "cdata" then
    C.cairo_region_create_rectangles(arg1, ...)
  elseif arg1 then
    return C.cairo_region_create_rectangle(set_int_rect(arg1, ...))
  else
    C.cairo_region_create()
  end
end, C.cairo_region_destroy)

local rgn = {}

rgn.copy = ref_func(C.cairo_region_copy, C.cairo_region_destroy)
rgn.ref = C.cairo_region_reference
rgn.unref = destroy_func(C.cairo_region_destroy)
rgn.free = free
rgn.equal = bool_func(C.cairo_region_equal)
rgn.status = C.cairo_region_status
rgn.status_message = status_message
rgn.check = check

rgn.extents = function(rgn)
  C.cairo_region_get_extents(rgn, ir)
  return unpack_rect(ir)
end

rgn.num_rectangles = C.cairo_region_num_rectangles

rgn.rectangle = function(rgn, i)
  C.cairo_region_get_rectangle(rgn, i, ir)
  return unpack_rect(ir)
end

rgn.is_empty = bool_func(C.cairo_region_is_empty)

local overlap = {
  [C.CAIRO_REGION_OVERLAP_IN] = true,
  [C.CAIRO_REGION_OVERLAP_OUT] = false,
  [C.CAIRO_REGION_OVERLAP_PART] = "partial",
}
function rgn.contains(x, y, w, h)
  if w then
    return overlap[C.cairo_region_contains_rectangle(
      rgn,
      set_int_rect(x, y, w, h)
    )]
  else
    return overlap[C.cairo_region_contains_point(rgn, x, y)]
  end
end

rgn.ref = ref_func(C.cairo_region_reference, C.cairo_region_destroy)
rgn.translate = C.cairo_region_translate

local function op_func(rgn_func_name)
  local rgn_func = C["cairo_" .. rgn_func_name]
  local rect_func = C["cairo_" .. rgn_func_name .. "_rectangle"]
  return function(rgn, x, y, w, h)
    if type(x) == "cdata" then
      check_status(rgn_func(rgn, x))
    else
      check_status(rect_func(rgn, set_int_rect(x, y, w, h)))
    end
  end
end
rgn.subtract = op_func("region_subtract")
rgn.intersect = op_func("region_intersect")
rgn.union = op_func("region_union")
rgn.xor = op_func("region_xor")

M.debug_reset_static_data = C.cairo_debug_reset_static_data

--private APIs available only in our custom build

map("CAIRO_LCD_FILTER_", {
  "DEFAULT",
  "NONE",
  "INTRA_PIXEL",
  "FIR3",
  "FIR5",
})

map("CAIRO_ROUND_GLYPH_POS_", {
  "DEFAULT",
  "ON",
  "OFF",
})

fopt.lcd_filter = getset_func(
  _C._cairo_font_options_get_lcd_filter,
  _C._cairo_font_options_set_lcd_filter,
  "CAIRO_LCD_FILTER_"
)

fopt.round_glyph_positions = getset_func(
  _C._cairo_font_options_get_round_glyph_positions,
  _C._cairo_font_options_set_round_glyph_positions,
  "CAIRO_ROUND_GLYPH_POS_"
)

--additions to context

function cr:safe_transform(mt)
  if mt:invertible() then
    self:transform(mt)
  end
  return self
end

function cr:rotate_around(cx, cy, angle)
  self:translate(cx, cy)
  self:rotate(angle)
  return self:translate(-cx, -cy)
end

function cr:scale_around(cx, cy, ...)
  self:translate(cx, cy)
  self:scale(...)
  return self:translate(-cx, -cy)
end

local sm = M.matrix()
function cr:skew(ax, ay)
  sm:reset()
  sm.xy = math.tan(ax)
  sm.yx = math.tan(ay)
  return self:transform(sm)
end

--additions to surfaces

function sr:apply_alpha(alpha)
  if alpha >= 1 then
    return
  end
  local cr = self:context()
  cr:rgba(0, 0, 0, alpha)
  cr:operator("dest_in") --alphas are multiplied, dest. color is preserved
  cr:paint()
  cr:free()
end

local bpp = {
  argb32 = 32,
  rgb24 = 32,
  a8 = 8,
  a1 = 1,
  rgb16_565 = 16,
  rgb30 = 30,
}
function sr:bpp()
  return bpp[self:format()]
end

function sr:bitmap_format()
  return M.bitmap_format(self:format())
end

function sr:bitmap()
  return {
    data = self:data(),
    format = self:bitmap_format(),
    w = self:width(),
    h = self:height(),
    stride = self:stride(),
  }
end

--additions to paths

local pi = math.pi
function cr:circle(cx, cy, r)
  self:new_sub_path()
  self:arc(cx, cy, r, 0, 2 * pi)
  self:close_path()
end

local mt0
function cr:ellipse(cx, cy, rx, ry, rotation)
  mt0 = self:matrix(nil, mt0)
  self:translate(cx, cy)
  if rotation then
    self:rotate(rotation)
  end
  self:scale(1, ry / rx)
  self:circle(0, 0, rx)
  self:matrix(mt0)
end

local function elliptic_arc_func(arc)
  return function(self, cx, cy, rx, ry, rotation, a1, a2)
    if rx == 0 or ry == 0 then
      if self:has_current_point() then
        self:line_to(cx, cy)
      end
    elseif rx ~= ry or (rotation and rotation ~= 0) then
      self:save()
      self:translate(cx, cy)
      self:rotate(rotation)
      self:scale(rx / ry, 1)
      arc(self, 0, 0, ry, a1, a2)
      self:restore()
    else
      arc(self, cx, cy, ry, a1, a2)
    end
  end
end
cr.elliptic_arc = elliptic_arc_func(cr.arc)
cr.elliptic_arc_negative = elliptic_arc_func(cr.arc_negative)

function cr:quad_curve_to(x1, y1, x2, y2)
  local x0, y0 = unpack(self:current_point())
  self:curve_to(
    (x0 + 2 * x1) / 3,
    (y0 + 2 * y1) / 3,
    (x2 + 2 * x1) / 3,
    (y2 + 2 * y1) / 3,
    x2,
    y2
  )
end

function cr:rel_quad_curve_to(x1, y1, x2, y2)
  local x0, y0 = unpack(self:current_point())
  self:quad_curve_to(x0 + x1, y0 + y1, x0 + x2, y0 + y2)
end

function cr:rounded_rectangle(x, y, width, height, corner_radius)
  local aspect = 1.0 -- aspect ratio

  local radius = corner_radius / aspect
  local degrees = math.pi / 180.0

  self:new_sub_path()
  self:arc(x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
  self:arc(
    x + width - radius,
    y + height - radius,
    radius,
    0 * degrees,
    90 * degrees
  )
  self:arc(x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
  self:arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
  self:close_path()
end

--additions to matrices

function mt:transform(mt)
  return self:multiply(mt, self)
end

function mt:determinant()
  return self.xx * self.yy - self.yx * self.xy
end

function mt:invertible()
  local det = self:determinant()
  return det ~= 0 and det ~= 1 / 0 and det ~= -1 / 0
end

function mt:safe_transform(self, mt)
  if mt:invertible() then
    self:transform(mt)
  end
  return self
end

function mt:skew(ax, ay)
  local sm = M.matrix()
  sm.xy = math.tan(ax)
  sm.yx = math.tan(ay)
  return self:transform(sm)
end

function mt:rotate_around(cx, cy, angle)
  self:translate(cx, cy)
  self:rotate(angle)
  self:translate(-cx, -cy)
  return self
end

function mt:scale_around(cx, cy, ...)
  self:translate(cx, cy)
  self:scale(...)
  self:translate(-cx, -cy)
  return self
end

function mt:copy()
  return M.matrix(self)
end

function mt.tostring(mt)
  return string.format(
    "[%12f%12f]\n[%12f%12f]\n[%12f%12f]",
    mt.xx,
    mt.yx,
    mt.xy,
    mt.yy,
    mt.x0,
    mt.y0
  )
end

function mt.equal(m1, m2)
  return type(m2) == "cdata"
    and m1.xx == m2.xx
    and m1.yy == m2.yy
    and m1.xy == m2.xy
    and m1.yx == m2.yx
    and m1.x0 == m2.x0
    and m1.y0 == m2.y0
end

--freetype extension

function M.ft_font_face(ft_face, load_flags)
  local ft = require("freetype")
  local key = ffi.new("cairo_user_data_key_t[1]")
  local face = ffi.gc(
    C.cairo_ft_font_face_create_for_ft_face(ft_face, load_flags or 0),
    C.cairo_font_face_destroy
  )
  local status = C.cairo_font_face_set_user_data(
    face,
    key,
    ft_face,
    ffi.cast("cairo_destroy_func_t", function()
      ft_face:free()
      ft_face.glyph.library:free()
    end)
  )
  if status ~= 0 then
    C.cairo_font_face_destroy(face)
    ft_face:free()
    return nil, M.status_message(status), status
  end
  ft_face.glyph.library:ref()
  return face
end

local function synthesize_flag(bitmask)
  return function(face, enable)
    if enable == nil then
      return bit.band(C.cairo_ft_font_face_get_synthesize(face), bitmask) ~= 0
    elseif enable then
      C.cairo_ft_font_face_set_synthesize(face, bitmask)
    else
      C.cairo_ft_font_face_unset_synthesize(face, bitmask)
    end
  end
end
face.synthesize_bold = synthesize_flag(C.CAIRO_FT_SYNTHESIZE_BOLD)
face.synthesize_oblique = synthesize_flag(C.CAIRO_FT_SYNTHESIZE_OBLIQUE)

sfont.lock_face = _C.cairo_ft_scaled_font_lock_face
sfont.unlock_face = _C.cairo_ft_scaled_font_unlock_face

--pdf surfaces

enums["CAIRO_PDF_VERSION_"] = {
  [C.CAIRO_PDF_VERSION_1_4] = "1.4",
  [C.CAIRO_PDF_VERSION_1_5] = "1.5",
  ["1.4"] = C.CAIRO_PDF_VERSION_1_4,
  ["1.5"] = C.CAIRO_PDF_VERSION_1_5,
}
M.pdf_surface = ref_func(function(arg1, ...)
  if type(arg1) == "string" then
    return C.cairo_pdf_surface_create(arg1, ...)
  else
    return C.cairo_pdf_surface_create_for_stream(arg1, ...)
  end
end, C.cairo_surface_destroy)

sr.pdf_version =
  setflag_func(_C.cairo_pdf_surface_restrict_to_version, "CAIRO_PDF_VERSION_")

local function listout_func(func, ct, prefix)
  return func
    and function()
      local ibuf = ffi.new("int[1]")
      local vbuf = ffi.new(ffi.typeof("const $*[1]", ffi.typeof(ct)))
      func(vbuf, ibuf)
      local t = {}
      for i = 0, ibuf[0] - 1 do
        t[#t + 1] = convert_prefix(prefix, tonumber(vbuf[0][i]))
      end
      return t
    end
end

M.pdf_versions = listout_func(
  _C.cairo_pdf_get_versions,
  "cairo_pdf_version_t",
  "CAIRO_PDF_VERSION_"
)
sr.pdf_size = _C.cairo_pdf_surface_set_size

--ps surfaces

map("CAIRO_PS_LEVEL_", { 2, 3 })

M.ps_surface = ref_func(function(arg1, ...)
  if type(arg1) == "string" then
    return C.cairo_ps_surface_create(arg1, ...)
  else
    return C.cairo_ps_surface_create_for_stream(arg1, ...)
  end
end, C.cairo_surface_destroy)

sr.ps_level =
  setflag_func(_C.cairo_ps_surface_restrict_to_level, "CAIRO_PS_LEVEL_")
M.ps_levels =
  listout_func(_C.cairo_ps_get_levels, "cairo_ps_level_t", "CAIRO_PS_LEVEL_")
sr.ps_eps = getset_func(
  bool_func(_C.cairo_ps_surface_get_eps),
  _C.cairo_ps_surface_set_eps
)
sr.ps_size = _C.cairo_ps_surface_set_size
sr.ps_dsc_comment = _C.cairo_ps_surface_dsc_comment
sr.ps_dsc_begin_setup = _C.cairo_ps_surface_dsc_begin_setup
sr.ps_dsc_begin_page_setup = _C.cairo_ps_surface_dsc_begin_page_setup

--svg surfaces

enums["CAIRO_SVG_VERSION_"] = {
  [C.CAIRO_SVG_VERSION_1_1] = "1.1",
  [C.CAIRO_SVG_VERSION_1_2] = "1.2",
  ["1.1"] = C.CAIRO_SVG_VERSION_1_1,
  ["1.2"] = C.CAIRO_SVG_VERSION_1_2,
}
M.svg_surface = ref_func(function(arg1, ...)
  if type(arg1) == "string" then
    return C.cairo_svg_surface_create(arg1, ...)
  else
    return C.cairo_svg_surface_create_for_stream(arg1, ...)
  end
end, C.cairo_surface_destroy)

sr.svg_version =
  setflag_func(_C.cairo_svg_surface_restrict_to_version, "CAIRO_SVG_VERSION_")
M.svg_versions = listout_func(
  _C.cairo_svg_get_versions,
  "cairo_svg_version_t",
  "CAIRO_SVG_VERSION_"
)

--metatype must come last

ffi.metatype("cairo_t", { __index = cr })
ffi.metatype("cairo_rectangle_list_t", { __index = rl })
ffi.metatype("cairo_glyph_t", { __index = glyph })
ffi.metatype("cairo_text_cluster_t", { __index = cluster })
ffi.metatype("cairo_font_options_t", { __index = fopt })
ffi.metatype("cairo_font_face_t", { __index = face })
ffi.metatype("cairo_scaled_font_t", { __index = sfont })
ffi.metatype("cairo_path_t", { __index = path })
ffi.metatype("cairo_device_t", { __index = dev })
ffi.metatype("cairo_surface_t", { __index = sr })
ffi.metatype("cairo_pattern_t", { __index = patt })
ffi.metatype("cairo_matrix_t", {
  __index = mt,
  __call = mt.point,
  __mul = function(mt1, mt2)
    return mt1:copy():multiply(mt2)
  end,
})
ffi.metatype("cairo_region_t", { __index = rgn })

ffi.metatype("cairo_text_extents_t", {
  __tostring = function(t)
    return string.format(
      "bearing: (%d, %d), height: %d, advance: (%d, %d)",
      t.x_bearing,
      t.y_bearing,
      t.width,
      t.height,
      t.x_advance,
      t.y_advance
    )
  end,
})

ffi.metatype("cairo_font_extents_t", {
  __tostring = function(t)
    return string.format(
      "ascent: %d, descent: %d, height: %d, max_advance: (%d, %d)",
      t.ascent,
      t.descent,
      t.height,
      t.max_x_advance,
      t.max_y_advance
    )
  end,
})

return M
