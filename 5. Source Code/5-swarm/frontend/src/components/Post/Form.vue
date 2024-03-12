<template>
  <div>
    <form>
      <label for="title">Title</label>
      <input type="text" v-model="post.title" id="title">

      <label for="headline">Headline</label>
      <input type="text" v-model="post.headline" id="headline">

      <label for="content">Content</label>
      <textarea v-model="post.content" id="content"></textarea>

      <label for="cover_photo">Cover photo</label>
      <input type="file" id="cover_photo" name="cover_photo" @change="fileSelected($event)">

      <button @click.prevent="submit">Submit</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'PostForm',

  data() {
    return {
      post: {},
    };
  },

  methods: {
    async submit() {
      const formData = new FormData();

      formData.append('cover_photo', this.post.cover_photo);

      for (const key in this.post) {
        formData.append(key, this.post[key]);
      }

      await axios.post(`/api/posts/`, formData, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('access_token')}`,
          'Content-Type': 'multipart/form-data',
        },
      });

      await this.$router.push({ name: 'posts-list' })
    },

    async fileSelected(event) {
      this.post.cover_photo = event.target.files[0];
    }
  }
}
</script>
