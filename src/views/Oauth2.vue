<template>
  <div>
    <div
      v-if="error"
      class="mb-10 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative"
      role="alert"
    >
      <span class="block sm:inline">{{ error }}</span>
    </div>
  </div>
</template>

<script>
import { fetch } from "@/util/data";

import {
  oauth2callbackurl,
  setLoggedUser,
  unsetLoginRedirect,
  getLoginRedirect
} from "@/util/auth";

export default {
  components: {},
  name: "Oauth2",
  props: {},
  data() {
    return {
      error: null,
      run: null,
      code: this.$route.query.code,
      polling: null,
      username: null
    };
  },
  methods: {
    async doOauth2() {
      //sam cp here
      // export function oauth2callbackurl() {
      //     return new URL(API_URL + "/api/oauth2/callback");
      // }

      let u = oauth2callbackurl();
      u.searchParams.append("code", this.$route.query.code);
      u.searchParams.append("state", this.$route.query.state);

      //TODO_A3
      // /api/oauth2/callback
      let { data, error } = await fetch(u);//前端发起后端的callback调用，完成oauth及agola自身登录
      if (error) {
        // set local login error on failed oauth2.
        this.error = error;
        return;
      }

      if (data.request_type === "loginuser") {
        setLoggedUser(data.response.token, data.response.user);
        let redirect = getLoginRedirect(redirect);
        if (redirect) {
          unsetLoginRedirect();
          this.$router.push(redirect);
        } else {
          this.$router.push({ name: "home" });
        }
      } else if (data.request_type === "authorize") {
        this.$store.dispatch("setRegisterUser", data.response);
        this.$router.push("/register");
      } else if (data.request_type === "createuserla") {
        this.$router.push({
          name: "user settings",
          params: { username: this.username }
        });
      }
    }
  },
  created: function() {
    this.doOauth2();
  }
};
</script>

