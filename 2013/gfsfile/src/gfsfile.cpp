#define MONGO_HAVE_STDINT

#include <v8.h>
#include <node.h>
#include <node_buffer.h>
#include <mongo.h>
#include <gridfs.h>

using namespace node;
using namespace v8;


Buffer *readBytes(gridfile *gfile, int start, int end) {

  int length = end - start;
  if (length <= 0) return NULL;

  Buffer *buffer = Buffer::New(length);

  gridfile_seek(gfile, start);
  gridfile_read(gfile, length, Buffer::Data(buffer));

  return buffer;

}

static Handle<Value> getGfsFile(const Arguments& args) {

  HandleScope scope;

  if (args.Length() != 4) {

    ThrowException(Exception::TypeError(String::New("Wrong number of arguments")));
    return scope.Close(Undefined());

  }

  Local<Object> configobj = args[0]->ToObject();

  if (configobj->Get(String::New("hostname"))->IsUndefined()
  || configobj->Get(String::New("port"))->IsUndefined()
  || configobj->Get(String::New("database"))->IsUndefined()) {

    ThrowException(Exception::TypeError(String::New("Wrong arguments in database config object")));
    return scope.Close(Undefined());

  }

  String::AsciiValue hostname(configobj->Get(String::New("hostname")));
  int port = configobj->Get(String::New("port"))->ToInteger()->Value();
  String::AsciiValue database(configobj->Get(String::New("database")));
  String::AsciiValue filename(args[1]);
  int start = args[2]->IntegerValue();
  int end = args[3]->IntegerValue();

  mongo conn[1];
  gridfs gfs[1];
  gridfile gfile[1];

  if (mongo_client(conn, *hostname, port) != MONGO_OK) {

    if (conn->err == MONGO_CONN_NO_SOCKET) {

      ThrowException(Exception::TypeError(String::New("MongoDB socket failed")));
      return scope.Close(Undefined());

    }
    else if (conn->err == MONGO_CONN_FAIL) {

      ThrowException(Exception::TypeError(String::New("MongoDB connection failed")));
      return scope.Close(Undefined());

    }
    else if (conn->err == MONGO_CONN_NOT_MASTER) {

      ThrowException(Exception::TypeError(String::New("MongoDB connection not master")));
      return scope.Close(Undefined());

    }

  }

  if (gridfs_init(conn, *database, NULL, gfs) != MONGO_OK) {

    mongo_destroy(conn);

    ThrowException(Exception::TypeError(String::New("GridFS initialization failed")));
    return scope.Close(Undefined());

  }

  if (gridfs_find_filename(gfs, *filename, gfile) != MONGO_OK) {

    gridfs_destroy(gfs);
    mongo_destroy(conn);

    ThrowException(Exception::TypeError(String::New("GridFS file does not exist")));
    return scope.Close(Undefined());

  }

  Buffer *buffer = readBytes(gfile, start, end);

  gridfs_destroy(gfs);
  mongo_destroy(conn);

  return scope.Close(buffer->handle_);

}

extern "C" void init(Handle<Object> target) {

  NODE_SET_METHOD(target, "getGfsFile", getGfsFile);

}
