<template>
  <div>
    <table>
      <tr>
        <th>Title</th>
        <th>Headline</th>
        <th>Publish at</th>
      </tr>
      <tr>
        <td>{{ post.title }}</td>
        <td>{{ post.headline }}</td>
        <td>{{ post.publish_at }}</td>
      </tr>
    </table>

    <img :src="post.cover_photo_url">
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'PostShow',

  data() {
    return {
      post: [],
    };
  },

  async created() {
    await this.fetch();
  },

  methods: {
    async fetch() {
      const { data } = await axios.get(`/api/posts/${this.$route.params.id}`, {
        headers: { 'Authorization': `Bearer ${localStorage.getItem('access_token')}` }
      });

      this.post = data.data;
    },
  }
}
</script>
