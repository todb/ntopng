/*
 *
 * (C) 2013-23 - ntop.org
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 */

#ifndef _REDIS_H_
#define _REDIS_H_

#include "ntop_includes.h"

class Host;

class Redis {
 private:
  redisContext *redis;
  Mutex *l;
  char *redis_host, *redis_password, *redis_version;
#ifdef __linux__
  bool is_socket_connection;
#endif
  struct {
    u_int32_t num_expire, num_get, num_ttl, num_del, num_hget, num_hset,
        num_hdel, num_set, num_keys, num_hkeys, num_llen, num_other,
        num_hgetall, num_trim, num_lpush_rpush, num_lpop_rpop, num_strlen,
        num_saved_lookups, num_get_address, num_set_resolved_address;
    u_int32_t num_reconnections;
  } stats;
  u_int32_t num_redis_version;
  u_int16_t redis_port;
  u_int8_t redis_db_id;
  pthread_t esThreadLoop;
  pthread_t lsThreadLoop;
  bool operational;
  bool initializationCompleted;
  std::map<std::string, StringCache> stringCache;
  StringFifoQueue *localToResolve, *remoteToResolve;
  u_int numCached;

  char *getRedisVersion();
  void reconnectRedis(bool giveup_on_failure);
  int msg_push(const char *cmd, const char *queue_name, const char *msg,
               u_int queue_trim_size, bool trace_errors = true,
               bool head_trim = false);
  int lrpop(const char *queue_name, char *buf, u_int buf_len, bool lpop);
  void addToCache(const char *key, const char *value, u_int expire_secs);
  bool isCacheable(const char *key);
  bool expireCache(char *key, u_int expire_sec);

  void checkDumpable(const char *key);
  int _set(bool use_nx, const char *key, const char *value, u_int expire_secs);

 public:
  Redis(const char *redis_host = (char *)"127.0.0.1",
        const char *redis_password = NULL, u_int16_t redis_port = 6379,
        u_int8_t _redis_db_id = 0, bool giveup_on_failure = false);
  ~Redis();

  inline char *getVersion() { return (redis_version); }
  inline u_int32_t getNumVersion() { return (num_redis_version); }
  inline bool haveRedisDump() {
    return ((num_redis_version >= 0x020600) ? true : false);
  }
  void setDefaults();
  inline bool isOperational() { return (operational); };
  inline void setInitializationComplete() { initializationCompleted = true; };
  int info(char *rsp, u_int rsp_len);
  u_int dbsize();
  int expire(char *key, u_int expire_sec);
  int get(char *key, char *rsp, u_int rsp_len, bool cache_it = false);
  int hashGet(const char *key, const char *member, char *const rsp,
              u_int rsp_len);
  int hashDel(const char *key, const char *field);
  int hashSet(const char *key, const char *field, const char *value);
  inline int set(const char *key, const char *value, u_int expire_secs = 0) {
    return (_set(false, key, value, expire_secs));
  }
  /* setnx = set if not existing */
  inline int setnx(const char *key, const char *value, u_int expire_secs = 0) {
    return (_set(true, key, value, expire_secs));
  }
  int keys(const char *pattern, char ***keys_p);
  int hashKeys(const char *pattern, char ***keys_p);
  int hashGetAll(const char *key, char ***keys_p, char ***values_p);
  int del(char *key);
  int pushHostToResolve(char *hostname, bool dont_check_for_existence,
                        bool localHost);
  int popHostToResolve(char *hostname, u_int hostname_len);

  int getAddress(char *numeric_ip, char *rsp, u_int rsp_len,
                 bool queue_if_not_found);
  int setResolvedAddress(char *numeric_ip, char *symbolic_ip);

  int sadd(const char *set_name, char *item);
  int srem(const char *set_name, char *item);
  int smembers(lua_State *vm, char *setName);
  int smembers(const char *set_name, char ***members);
  bool sismember(const char *set_name, const char *member);

  int lpush(const char *queue_name, const char *msg, u_int queue_trim_size,
            bool trace_errors = true);
  int rpush(const char *queue_name, const char *msg, u_int queue_trim_size);
  int lindex(const char *queue_name, int idx, char *buf, u_int buf_len);
  int ltrim(const char *queue_name, int start_idx, int end_idx);
  u_int hstrlen(const char *key, const char *value);
  u_int len(const char *key);
  u_int llen(const char *queue_name);
  int lset(const char *queue_name, u_int32_t idx, const char *value);
  int lrem(const char *queue_name, const char *value);
  int lrange(const char *list_name, char ***elements, int start_offset,
             int end_offset);
  int lpop(const char *queue_name, char *buf, u_int buf_len);
  int rpop(const char *queue_name, char *buf, u_int buf_len);
  int incr(const char *key, int amount);
  int flushDb();
  void flushCache();
  void lua(lua_State *vm);
  char *dump(char *key);
  int restore(char *key, char *buf);
};

#endif /* _REDIS_H_ */
