function [post_means, postsb] = post_calc(posts)

    postsb = posts/sum(sum(posts));
    %posts = bsxfun(@rdivide, posts, sum(posts, 2));

    %store in results
    post_means = mean(bsxfun(@rdivide, postsb, sum(postsb, 2)), 1);        