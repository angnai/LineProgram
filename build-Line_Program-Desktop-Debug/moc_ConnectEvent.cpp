/****************************************************************************
** Meta object code from reading C++ file 'ConnectEvent.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../QT/ConnectEvent.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ConnectEvent.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_ConnectEvent_t {
    QByteArrayData data[10];
    char stringdata0[118];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ConnectEvent_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ConnectEvent_t qt_meta_stringdata_ConnectEvent = {
    {
QT_MOC_LITERAL(0, 0, 12), // "ConnectEvent"
QT_MOC_LITERAL(1, 13, 17), // "cppSignaltestData"
QT_MOC_LITERAL(2, 31, 0), // ""
QT_MOC_LITERAL(3, 32, 14), // "slotTimerAlarm"
QT_MOC_LITERAL(4, 47, 14), // "qmlTestDataAll"
QT_MOC_LITERAL(5, 62, 14), // "qmlTestDataGet"
QT_MOC_LITERAL(6, 77, 15), // "qmlIndexDataAll"
QT_MOC_LITERAL(7, 93, 7), // "nIndexA"
QT_MOC_LITERAL(8, 101, 11), // "qmlSetTrans"
QT_MOC_LITERAL(9, 113, 4) // "nSet"

    },
    "ConnectEvent\0cppSignaltestData\0\0"
    "slotTimerAlarm\0qmlTestDataAll\0"
    "qmlTestDataGet\0qmlIndexDataAll\0nIndexA\0"
    "qmlSetTrans\0nSet"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ConnectEvent[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   44,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       3,    0,   47,    2, 0x0a /* Public */,

 // methods: name, argc, parameters, tag, flags
       4,    0,   48,    2, 0x02 /* Public */,
       5,    0,   49,    2, 0x02 /* Public */,
       6,    1,   50,    2, 0x02 /* Public */,
       8,    1,   53,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QVariant,    2,

 // slots: parameters
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void,
    QMetaType::QString,
    QMetaType::Void, QMetaType::Int,    7,
    QMetaType::Void, QMetaType::Int,    9,

       0        // eod
};

void ConnectEvent::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ConnectEvent *_t = static_cast<ConnectEvent *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->cppSignaltestData((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 1: _t->slotTimerAlarm(); break;
        case 2: _t->qmlTestDataAll(); break;
        case 3: { QString _r = _t->qmlTestDataGet();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 4: _t->qmlIndexDataAll((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 5: _t->qmlSetTrans((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ConnectEvent::*)(QVariant );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&ConnectEvent::cppSignaltestData)) {
                *result = 0;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject ConnectEvent::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ConnectEvent.data,
      qt_meta_data_ConnectEvent,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *ConnectEvent::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ConnectEvent::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ConnectEvent.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ConnectEvent::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void ConnectEvent::cppSignaltestData(QVariant _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
