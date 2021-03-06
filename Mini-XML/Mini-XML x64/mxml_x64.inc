;
; Header file for Mini-XML, a small XML-like file parsing library.
;
; Copyright 2003-2016 by Michael R Sweet.
;
; These coded instructions, statements, and computer programs are the
; property of Michael R Sweet and are protected by Federal copyright
; law.  Distribution and use rights are outlined in the file "COPYING"
; which should have been included with this file.  If this file is
; missing or damaged, see the license at:
;
;   http://www.msweet.org/projects.php/Mini-XML
;

; mxml_x64.inc converted from mxml.h for assembler by fearless 2017


; Prototypes...

mxmlAdd                     PROTO :QWORD, :QWORD, :QWORD, :QWORD                  ; extern void           mxmlAdd(mxml_node_t *parent, int where, mxml_node_t *child, mxml_node_t *node);
mxmlDelete                  PROTO :QWORD                                          ; extern void           mxmlDelete(mxml_node_t *node);
mxmlElementDeleteAttr       PROTO :QWORD, :QWORD                                  ; extern void           mxmlElementDeleteAttr(mxml_node_t *node, const char *name);
mxmlElementGetAttr          PROTO :QWORD, :QWORD                                  ; extern const char     *mxmlElementGetAttr(mxml_node_t *node, const char *name);
mxmlElementGetAttrByIndex   PROTO :QWORD, :QWORD, :QWORD                        ; extern const char     *mxmlElementGetAttrByIndex(mxml_node_t *node, int idx, const char **name);
mxmlElementGetAttrCount     PROTO :QWORD                                          ; extern int            mxmlElementGetAttrCount(mxml_node_t *node);
mxmlElementSetAttr          PROTO :QWORD, :QWORD, :QWORD                          ; extern void           mxmlElementSetAttr(mxml_node_t *node, const char *name, const char *value);
;mxmlElementSetAttrf        PROTO :QWORD, :QWORD, :QWORD                          ; extern void           mxmlElementSetAttrf(mxml_node_t *node, const char *name, const char *format, ...)

mxmlEntityAddCallback       PROTO :QWORD                                          ; extern int            mxmlEntityAddCallback(mxml_entity_cb_t cb);
mxmlEntityGetName           PROTO :QWORD                                          ; extern const char     *mxmlEntityGetName(int val);
mxmlEntityGetValue          PROTO :QWORD                                          ; extern int            mxmlEntityGetValue(const char *name);
mxmlEntityRemoveCallback    PROTO :QWORD                                         ; extern void           mxmlEntityRemoveCallback(mxml_entity_cb_t cb);
mxmlFindElement             PROTO :QWORD, :QWORD, :QWORD, :QWORD, :QWORD, :QWORD  ; extern mxml_node_t    *mxmlFindElement(mxml_node_t *node, mxml_node_t *top, const char *name, const char *attr, const char *value, int descend);
mxmlFindPath                PROTO :QWORD, :QWORD                                  ; extern mxml_node_t    *mxmlFindPath(mxml_node_t *node, const char *path);
mxmlGetCDATA                PROTO :QWORD                                          ; extern const char     *mxmlGetCDATA(mxml_node_t *node);
mxmlGetCustom               PROTO :QWORD                                          ; extern const void     *mxmlGetCustom(mxml_node_t *node);
mxmlGetElement              PROTO :QWORD                                          ; extern const char     *mxmlGetElement(mxml_node_t *node);
mxmlGetFirstChild           PROTO :QWORD                                          ; extern mxml_node_t    *mxmlGetFirstChild(mxml_node_t *node);
mxmlGetInteger              PROTO :QWORD                                          ; extern int            mxmlGetInteger(mxml_node_t *node);
mxmlGetLastChild            PROTO :QWORD                                          ; extern mxml_node_t    *mxmlGetLastChild(mxml_node_t *node);
mxmlGetNextSibling          PROTO :QWORD                                          ; extern mxml_node_t    *mxmlGetNextSibling(mxml_node_t *node);
mxmlGetOpaque               PROTO :QWORD                                          ; extern const char     *mxmlGetOpaque(mxml_node_t *node);
mxmlGetParent               PROTO :QWORD                                          ; extern mxml_node_t    *mxmlGetParent(mxml_node_t *node);
mxmlGetPrevSibling          PROTO :QWORD                                          ; extern mxml_node_t    *mxmlGetPrevSibling(mxml_node_t *node);
mxmlGetReal                 PROTO :QWORD                                          ; extern double         mxmlGetReal(mxml_node_t *node);
mxmlGetRefCount             PROTO :QWORD                                          ; extern int            mxmlGetRefCount(mxml_node_t *node);
mxmlGetText                 PROTO :QWORD, :QWORD                                  ; extern const char     *mxmlGetText(mxml_node_t *node, int *whitespace);
mxmlGetType                 PROTO :QWORD                                          ; extern mxml_type_t    mxmlGetType(mxml_node_t *node);
mxmlGetUserData             PROTO :QWORD                                          ; extern void           *mxmlGetUserData(mxml_node_t *node);
mxmlIndexDelete             PROTO :QWORD                                          ; extern void           mxmlIndexDelete(mxml_index_t *ind);
mxmlIndexEnum               PROTO :QWORD                                          ; extern mxml_node_t    *mxmlIndexEnum(mxml_index_t *ind);
mxmlIndexFind               PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlIndexFind(mxml_index_t *ind, const char *element, const char *value);
mxmlIndexGetCount           PROTO :QWORD                                          ; extern int            mxmlIndexGetCount(mxml_index_t *ind);
mxmlIndexNew                PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_index_t   *mxmlIndexNew(mxml_node_t *node, const char *element, const char *attr);
mxmlIndexReset              PROTO :QWORD                                          ; extern mxml_node_t    *mxmlIndexReset(mxml_index_t *ind);
mxmlLoadFd                  PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlLoadFd(mxml_node_t *top, int fd, mxml_type_t (*cb)(mxml_node_t *));
mxmlLoadFile                PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlLoadFile(mxml_node_t *top, FILE *fp, mxml_type_t (*cb)(mxml_node_t *));
mxmlLoadString              PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlLoadString(mxml_node_t *top, const char *s, mxml_type_t (*cb)(mxml_node_t *));
mxmlNewCDATA                PROTO :QWORD, :QWORD                                  ; extern mxml_node_t    *mxmlNewCDATA(mxml_node_t *parent, const char *string);
mxmlNewCustom               PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlNewCustom(mxml_node_t *parent, void *data, mxml_custom_destroy_cb_t destroy);
mxmlNewElement              PROTO :QWORD, :QWORD                                  ; extern mxml_node_t    *mxmlNewElement(mxml_node_t *parent, const char *name);
mxmlNewInteger              PROTO :QWORD, :QWORD                                  ; extern mxml_node_t    *mxmlNewInteger(mxml_node_t *parent, int integer);
mxmlNewOpaque               PROTO :QWORD, :QWORD                                  ; extern mxml_node_t    *mxmlNewOpaque(mxml_node_t *parent, const char *opaque);
mxmlNewReal                 PROTO :QWORD, :QWORD                                  ; extern mxml_node_t    *mxmlNewReal(mxml_node_t *parent, double real);
mxmlNewText                 PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlNewText(mxml_node_t *parent, int whitespace, const char *string);
;mxmlNewTextf               PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlNewTextf(mxml_node_t *parent, int whitespace, const char *format, ...)

mxmlNewXML                  PROTO :QWORD                                          ; extern mxml_node_t    *mxmlNewXML(const char *version);
mxmlRelease                 PROTO :QWORD                                          ; extern int            mxmlRelease(mxml_node_t *node);
mxmlRemove                  PROTO :QWORD                                          ; extern void           mxmlRemove(mxml_node_t *node);
mxmlRetain                  PROTO :QWORD                                          ; extern int            mxmlRetain(mxml_node_t *node);
mxmlSaveAllocString         PROTO :QWORD, :QWORD                                  ; extern char           *mxmlSaveAllocString(mxml_node_t *node, mxml_save_cb_t cb);
mxmlSaveFd                  PROTO :QWORD, :QWORD, :QWORD                          ; extern int            mxmlSaveFd(mxml_node_t *node, int fd, mxml_save_cb_t cb);
mxmlSaveFile                PROTO :QWORD, :QWORD, :QWORD                          ; extern int            mxmlSaveFile(mxml_node_t *node, FILE *fp, mxml_save_cb_t cb);
mxmlSaveString              PROTO :QWORD, :QWORD, :QWORD, :QWORD                  ; extern int            mxmlSaveString(mxml_node_t *node, char *buffer, int bufsize, mxml_save_cb_t cb);
mxmlSAXLoadFd               PROTO :QWORD, :QWORD, :QWORD, :QWORD, :QWORD          ; extern mxml_node_t    *mxmlSAXLoadFd(mxml_node_t *top, int fd, mxml_type_t (*cb)(mxml_node_t *), mxml_sax_cb_t sax, void *sax_data);
mxmlSAXLoadFile             PROTO :QWORD, :QWORD, :QWORD, :QWORD, :QWORD          ; extern mxml_node_t    *mxmlSAXLoadFile(mxml_node_t *top, FILE *fp, mxml_type_t (*cb)(mxml_node_t *), mxml_sax_cb_t sax, void *sax_data);
mxmlSAXLoadString           PROTO :QWORD, :QWORD, :QWORD, :QWORD, :QWORD          ; extern mxml_node_t    *mxmlSAXLoadString(mxml_node_t *top, const char *s,  mxml_type_t (*cb)(mxml_node_t *), mxml_sax_cb_t sax, void *sax_data);
mxmlSetCDATA                PROTO :QWORD, :QWORD                                  ; extern int            mxmlSetCDATA(mxml_node_t *node, const char *data);
mxmlSetCustom               PROTO :QWORD, :QWORD, :QWORD                          ; extern int            mxmlSetCustom(mxml_node_t *node, void *data, mxml_custom_destroy_cb_t destroy);
mxmlSetCustomHandlers       PROTO :QWORD, :QWORD                                  ; extern void           mxmlSetCustomHandlers(mxml_custom_load_cb_t load, mxml_custom_save_cb_t save);
mxmlSetElement              PROTO :QWORD, :QWORD                                  ; extern int            mxmlSetElement(mxml_node_t *node, const char *name);
mxmlSetErrorCallback        PROTO :QWORD                                          ; extern void           mxmlSetErrorCallback(mxml_error_cb_t cb);
mxmlSetInteger              PROTO :QWORD, :QWORD                                  ; extern int            mxmlSetInteger(mxml_node_t *node, int integer);
mxmlSetOpaque               PROTO :QWORD, :QWORD                                  ; extern int            mxmlSetOpaque(mxml_node_t *node, const char *opaque);
mxmlSetReal                 PROTO :QWORD, :QWORD                                  ; extern int            mxmlSetReal(mxml_node_t *node, double real);
mxmlSetText                 PROTO :QWORD, :QWORD, :QWORD                          ; extern int            mxmlSetText(mxml_node_t *node, int whitespace, const char *string);
;mxmlSetTextf               PROTO :QWORD, :QWORD, :QWORD                          ; extern int            mxmlSetTextf(mxml_node_t *node, int whitespace, const char *format, ...)

mxmlSetUserData             PROTO :QWORD, :QWORD                                  ; extern int            mxmlSetUserData(mxml_node_t *node, void *data);
mxmlSetWrapMargin           PROTO :QWORD                                          ; extern void           mxmlSetWrapMargin(int column);
mxmlWalkNext                PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlWalkNext(mxml_node_t *node, mxml_node_t *top, int descend);
mxmlWalkPrev                PROTO :QWORD, :QWORD, :QWORD                          ; extern mxml_node_t    *mxmlWalkPrev(mxml_node_t *node, mxml_node_t *top, int descend);

; Semi-private functions / callbacks
;mxml_error extern void     mxml_error(const char *format, ...);
mxml_ignore_cb              PROTO :QWORD                                          ; extern mxml_type_t    mxml_ignore_cb(mxml_node_t *node);
mxml_integer_cb             PROTO :QWORD                                          ; extern mxml_type_t    mxml_integer_cb(mxml_node_t *node);
mxml_opaque_cb              PROTO :QWORD                                          ; extern mxml_type_t    mxml_opaque_cb(mxml_node_t *node);
mxml_real_cb                PROTO :DWORD                                          ; extern mxml_type_t    mxml_real_cb(mxml_node_t *node);
mxml_entity_cb              PROTO :QWORD                                          ; extern int (*mxml_entity_cb_t)(const char *);
mxml_load_cb                PROTO :QWORD                                          ; extern mxml_type_t (*mxml_load_cb_t)(mxml_node_t *); 
mxml_save_cb                PROTO :QWORD, :QWORD                                  ; const char *(*mxml_save_cb_t)(mxml_node_t *, int);
mxml_sax_cb                 PROTO :QWORD, :QWORD, :QWORD                          ; void (*mxml_sax_cb_t)(mxml_node_t *, mxml_sax_event_t, void *);
mxml_custom_load_cb         PROTO :QWORD, :QWORD                                  ; int (*mxml_custom_load_cb_t)(mxml_node_t *, const char *);
mxml_custom_save_cb         PROTO :QWORD                                          ; char *(*mxml_custom_save_cb_t)(mxml_node_t *);
mxml_custom_destroy_cb      PROTO                                                 ; void (*mxml_custom_destroy_cb_t)(void *);
mxml_error_cb               PROTO :QWORD                                          ; void (*mxml_error_cb_t)(const char *); 


; Typedefs
MXML_ATTR_S                 TYPEDEF MXML_ATTR_T
MXML_ELEMENT_S              TYPEDEF MXML_ELEMENT_T
MXML_TEXT_S                 TYPEDEF MXML_TEXT_T
MXML_CUSTOM_S               TYPEDEF MXML_CUSTOM_T
MXML_VALUE_S                TYPEDEF MXML_VALUE_T
MXML_NODE_S                 TYPEDEF MXML_NODE_T
MXML_INDEX_S                TYPEDEF MXML_INDEX_T


; Structures
MXML_ATTR_T                 STRUCT 8; An XML element attribute value. @private@ 
    attr_name               QWORD ?;    char *name              ; Attribute name
    attr_value              QWORD ?;    char *value             ; Attribute value
MXML_ATTR_T                 ENDS

MXML_ELEMENT_T              STRUCT 8; An XML element value. @private@
    element_name            QWORD ? ;   char *name              ; Name of element
    num_attrs               QWORD ? ;   int                     ; Number of attributes
    attrs                   QWORD ? ;   mxml_attr_t *attrs;     ; Attributes
MXML_ELEMENT_T              ENDS

MXML_TEXT_T                 STRUCT 8 ; An XML text value. @private@
    whitespace              QWORD ? ;   int                     ;Leading whitespace?
    string                  QWORD ? ;   char*string             ; Fragment string
MXML_TEXT_T                 ENDS

MXML_CUSTOM_T               STRUCT 8; An XML custom value. @private@
    data                    QWORD ? ;   void            *       ; Pointer to (allocated) custom data 
    destroy                 QWORD ? ;   mxml_custom_destroy_cb_t; Pointer to destructor function
MXML_CUSTOM_T               ENDS

MXML_VALUE_T                STRUCT 8; An XML node value. @private@
    element                 MXML_ELEMENT_T <> ; mxml_element_t  ; Element
    integer                 QWORD ? ;   int                     ; Integer number
    opaque                  QWORD ? ;   char *                  ; Opaque string
    real                    REAL4 ? ;   double                  ; Real number
    text                    MXML_TEXT_T <> ; mxml_text_t struct ; Text fragment
    custom                  MXML_CUSTOM_T <>;mxml_custom_t struc; Custom data @since Mini-XML 2.1@
MXML_VALUE_T                ENDS

MXML_NODE_T                 STRUCT 8; An XML node. @private@
    nodetype                QWORD ? ;   Node type
    next                    QWORD ? ;   pointer to mxml_node_t  *   ; Next node under same parent
    prev                    QWORD ? ;   pointer to mxml_node_t  *   ; Previous node under same parent
    parent                  QWORD ? ;   pointer to mxml_node_t  *   ; Parent node
    child                   QWORD ? ;   pointer to mxml_node_t  *   ; First child node
    last_child              QWORD ? ;   pointer to mxml_node_t  *   ; Last child nod
    node_value              MXML_VALUE_T <> ; mxml_value_t struct   ; Node value
    ref_count               QWORD ? ;   int                         ; Use count
    user_data               QWORD ? ;   pointer to user data        ; User data
MXML_NODE_T                 ENDS

MXML_INDEX_T                STRUCT 8; An XML node index. @private@
    attr                    QWORD ? ;   char    *   ; Attribute used for indexing or NULL
    num_nodes               QWORD ? ;   int         ; Number of nodes in index
    alloc_nodes             QWORD ? ;   int         ; Allocated nodes in index
    cur_node                QWORD ? ;   int         ; Current node
    nodes                   QWORD ? ;   mxml_node_t **mxml_node_t <>; Node array
MXML_INDEX_T                ENDS


.CONST
; Constants...
MXML_MAJOR_VERSION          EQU 2   ; Major version number
MXML_MINOR_VERSION          EQU 11  ; Minor version number

MXML_TAB                    EQU 8   ; Tabs every N columns

MXML_NO_CALLBACK            EQU 0   ; Don't use a type callback
MXML_INTEGER_CALLBACK       EQU 1   ; Treat all data as integers
MXML_OPAQUE_CALLBACK        EQU 2   ; Treat all data as opaque
MXML_REAL_CALLBACK          EQU 3   ; Treat all data as real numbers
MXML_TEXT_CALLBACK          EQU 0   ; Treat all data as text
MXML_IGNORE_CALLBACK        EQU -1  ; Ignore all non-element content

MXML_NO_PARENT              EQU 0   ; No parent for the node

MXML_DESCEND                EQU 1   ; Descend when finding/walking
MXML_NO_DESCEND             EQU 0   ; Don't descend when finding/walking
MXML_DESCEND_FIRST          EQU -1  ; Descend for first find

MXML_WS_BEFORE_OPEN         EQU 0   ; Callback for before open tag
MXML_WS_AFTER_OPEN          EQU 1   ; Callback for after open tag
MXML_WS_BEFORE_CLOSE        EQU 2   ; Callback for before close tag
MXML_WS_AFTER_CLOSE         EQU 3   ; Callback for after close tag

MXML_ADD_BEFORE             EQU 0   ; Add node before specified node
MXML_ADD_AFTER              EQU 1   ; Add node after specified node
MXML_ADD_TO_PARENT          EQU NULL; Add node relative to parent

; Enumerations
; enum mxml_sax_event_e     ; SAX event type.
MXML_SAX_CDATA              EQU 0   ; CDATA node
MXML_SAX_COMMENT            EQU 1   ; Comment node
MXML_SAX_DATA               EQU 2   ; Data node
MXML_SAX_DIRECTIVE          EQU 3   ; Processing directive node
MXML_SAX_ELEMENT_CLOSE      EQU 4   ; Element closed
MXML_SAX_ELEMENT_OPEN       EQU 5   ; Element opened

; enum mxml_type_e          ; The XML node type.
MXML_IGNORE                 EQU -1  ; Ignore/throw away node @since Mini-XML 2.3@
MXML_ELEMENT                EQU 0   ; XML element with attributes
MXML_INTEGER                EQU 1   ; Integer value
MXML_OPAQUE                 EQU 2   ; Opaque string
MXML_REAL                   EQU 3   ; Real value
MXML_TEXT                   EQU 4   ; Text fragment
MXML_CUSTOM                 EQU 5   ; Custom data @since Mini-XML 2.1@