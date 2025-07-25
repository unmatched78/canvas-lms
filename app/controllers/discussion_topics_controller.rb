# frozen_string_literal: true

#
# Copyright (C) 2011 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

# @API Discussion Topics
#
# API for accessing and participating in discussion topics in groups and courses.
#
# @model FileAttachment
#     {
#       "id": "FileAttachment",
#       "description": "A file attachment",
#       "properties": {
#         "content-type": {
#           "example": "unknown/unknown",
#           "type": "string"
#         },
#         "url": {
#           "example": "http://www.example.com/courses/1/files/1/download",
#           "type": "string"
#         },
#         "filename": {
#           "example": "content.txt",
#           "type": "string"
#         },
#         "display_name": {
#           "example": "content.txt",
#           "type": "string"
#         }
#       }
#     }
#
# @model DiscussionTopic
#     {
#       "id": "DiscussionTopic",
#       "description": "A discussion topic",
#       "properties": {
#         "id": {
#           "description": "The ID of this topic.",
#           "example": 1,
#           "type": "integer"
#         },
#         "title": {
#           "description": "The topic title.",
#           "example": "Topic 1",
#           "type": "string"
#         },
#         "message": {
#           "description": "The HTML content of the message body.",
#           "example": "<p>content here</p>",
#           "type": "string"
#         },
#         "html_url": {
#           "description": "The URL to the discussion topic in canvas.",
#           "example": "https://<canvas>/courses/1/discussion_topics/2",
#           "type": "string"
#         },
#         "posted_at": {
#           "description": "The datetime the topic was posted. If it is null it hasn't been posted yet. (see delayed_post_at)",
#           "example": "2037-07-21T13:29:31Z",
#           "type": "datetime"
#         },
#         "last_reply_at": {
#           "description": "The datetime for when the last reply was in the topic.",
#           "example": "2037-07-28T19:38:31Z",
#           "type": "datetime"
#         },
#         "require_initial_post": {
#           "description": "If true then a user may not respond to other replies until that user has made an initial reply. Defaults to false.",
#           "example": false,
#           "type": "boolean"
#         },
#         "user_can_see_posts": {
#           "description": "Whether or not posts in this topic are visible to the user.",
#           "example": true,
#           "type": "boolean"
#         },
#         "discussion_subentry_count": {
#           "description": "The count of entries in the topic.",
#           "example": 0,
#           "type": "integer"
#         },
#         "read_state": {
#           "description": "The read_state of the topic for the current user, 'read' or 'unread'.",
#           "example": "read",
#           "type": "string",
#           "allowableValues": {
#             "values": [
#               "read",
#               "unread"
#             ]
#           }
#         },
#         "unread_count": {
#           "description": "The count of unread entries of this topic for the current user.",
#           "example": 0,
#           "type": "integer"
#         },
#         "subscribed": {
#           "description": "Whether or not the current user is subscribed to this topic.",
#           "example": true,
#           "type": "boolean"
#         },
#         "subscription_hold": {
#           "description": "(Optional) Why the user cannot subscribe to this topic. Only one reason will be returned even if multiple apply. Can be one of: 'initial_post_required': The user must post a reply first; 'not_in_group_set': The user is not in the group set for this graded group discussion; 'not_in_group': The user is not in this topic's group; 'topic_is_announcement': This topic is an announcement",
#           "example": "not_in_group_set",
#           "type": "string",
#           "allowableValues": {
#             "values": [
#               "initial_post_required",
#               "not_in_group_set",
#               "not_in_group",
#               "topic_is_announcement"
#             ]
#           }
#         },
#         "assignment_id": {
#           "description": "The unique identifier of the assignment if the topic is for grading, otherwise null.",
#           "type": "integer"
#         },
#         "delayed_post_at": {
#           "description": "The datetime to publish the topic (if not right away).",
#           "type": "datetime"
#         },
#         "published": {
#           "description": "Whether this discussion topic is published (true) or draft state (false)",
#           "example": true,
#           "type": "boolean"
#         },
#         "lock_at": {
#           "description": "The datetime to lock the topic (if ever).",
#           "type": "datetime"
#         },
#         "locked": {
#           "description": "Whether or not the discussion is 'closed for comments'.",
#           "example": false,
#           "type": "boolean"
#         },
#         "pinned": {
#           "description": "Whether or not the discussion has been 'pinned' by an instructor",
#           "example": false,
#           "type": "boolean"
#         },
#         "locked_for_user": {
#           "description": "Whether or not this is locked for the user.",
#           "example": true,
#           "type": "boolean"
#         },
#         "lock_info": {
#           "description": "(Optional) Information for the user about the lock. Present when locked_for_user is true.",
#           "$ref": "LockInfo"
#         },
#         "lock_explanation": {
#           "description": "(Optional) An explanation of why this is locked for the user. Present when locked_for_user is true.",
#           "example": "This discussion is locked until September 1 at 12:00am",
#           "type": "string"
#         },
#         "user_name": {
#           "description": "The username of the topic creator.",
#           "example": "User Name",
#           "type": "string"
#         },
#         "topic_children": {
#           "description": "DEPRECATED An array of topic_ids for the group discussions the user is a part of.",
#           "example": [5, 7, 10],
#           "type": "array",
#           "items": { "type": "integer"}
#         },
#         "group_topic_children": {
#           "description": "An array of group discussions the user is a part of. Fields include: id, group_id",
#           "example": [{"id": 5, "group_id": 1}, {"id": 7, "group_id": 5}, {"id": 10, "group_id": 4}],
#           "type": "array",
#           "items": { "type": "object"}
#         },
#         "root_topic_id": {
#           "description": "If the topic is for grading and a group assignment this will point to the original topic in the course.",
#           "type": "integer"
#         },
#         "podcast_url": {
#           "description": "If the topic is a podcast topic this is the feed url for the current user.",
#           "example": "/feeds/topics/1/enrollment_1XAcepje4u228rt4mi7Z1oFbRpn3RAkTzuXIGOPe.rss",
#           "type": "string"
#         },
#         "discussion_type": {
#           "description": "The type of discussion. Values are 'side_comment' or 'not_threaded', for discussions that only allow one level of nested comments, and 'threaded' for fully threaded discussions.",
#           "example": "side_comment",
#           "type": "string",
#           "allowableValues": {
#             "values": [
#               "side_comment",
#               "not_threaded",
#               "threaded"
#             ]
#           }
#         },
#         "group_category_id": {
#           "description": "The unique identifier of the group category if the topic is a group discussion, otherwise null.",
#           "type": "integer"
#         },
#         "attachments": {
#           "description": "Array of file attachments.",
#           "type": "array",
#           "items": { "$ref": "FileAttachment" }
#         },
#         "permissions": {
#           "description": "The current user's permissions on this topic.",
#           "example": {"attach": true},
#           "type": "object",
#           "key": { "type": "string" },
#           "value": { "type": "boolean" }
#         },
#         "allow_rating": {
#           "description": "Whether or not users can rate entries in this topic.",
#           "example": true,
#           "type": "boolean"
#         },
#         "only_graders_can_rate": {
#           "description": "Whether or not grade permissions are required to rate entries.",
#           "example": true,
#           "type": "boolean"
#         },
#         "sort_by_rating": {
#           "description": "DEPRECATED, Whether or not entries should be sorted by rating.",
#           "example": true,
#           "type": "boolean"
#         },
#         "sort_order": {
#           "description": "How entries should be sorted by default.",
#           "example": "asc",
#           "type": "string",
#           "allowableValues": {
#             "values": [
#               "asc",
#               "desc"
#             ]
#           }
#         },
#         "sort_order_locked": {
#           "description": "Can users decide their preferred sort order.",
#           "example": true,
#           "type": "boolean"
#         },
#         "expand": {
#           "description": "Threaded replies should be expanded by default.",
#           "example": true,
#           "type": "boolean"
#         },
#         "expand_locked": {
#           "description": "Can users decide their preferred thread expand setting.",
#           "example": true,
#           "type": "boolean"
#         }
#       }
#     }
#
class DiscussionTopicsController < ApplicationController
  before_action :require_context_and_read_access, except: :public_feed

  include HorizonMode
  before_action :load_canvas_career, only: [:index, :show]

  before_action :rce_js_env

  include Api::V1::DiscussionTopics
  include Api::V1::Assignment
  include Api::V1::AssignmentOverride
  include KalturaHelper
  include SubmittableHelper
  include K5Mode
  include DiscussionTopicsHelper

  ANONYMOUS_STATES = ["full_anonymity", "partial_anonymity"].freeze

  # @API List discussion topics
  #
  # Returns the paginated list of discussion topics for this course or group.
  #
  # @argument include[] [String, "all_dates", "sections", "sections_user_count", "overrides"]
  #   If "all_dates" is passed, all dates associated with graded discussions'
  #   assignments will be included.
  #   if "sections" is passed, includes the course sections that are associated
  #   with the topic, if the topic is specific to certain sections of the course.
  #   If "sections_user_count" is passed, then:
  #     (a) If sections were asked for *and* the topic is specific to certain
  #         course sections, includes the number of users in each
  #         section. (as part of the section json asked for above)
  #     (b) Else, includes at the root level the total number of users in the
  #         topic's context (group or course) that the topic applies to.
  #   If "overrides" is passed, the overrides for the assignment will be included
  #
  # @argument order_by [String, "position"|"recent_activity"|"title"]
  #   Determines the order of the discussion topic list. Defaults to "position".
  #
  # @argument scope [String, "locked"|"unlocked"|"pinned"|"unpinned"]
  #   Only return discussion topics in the given state(s). Defaults to including
  #   all topics. Filtering is done after pagination, so pages
  #   may be smaller than requested if topics are filtered.
  #   Can pass multiple states as comma separated string.
  #
  # @argument only_announcements [Boolean]
  #   Return announcements instead of discussion topics. Defaults to false
  #
  # @argument filter_by [String, "all", "unread"]
  #   The state of the discussion topic to return. Currently only supports unread state.
  #
  # @argument search_term [String]
  #   The partial title of the discussion topics to match and return.
  #
  # @argument exclude_context_module_locked_topics [Boolean]
  #   For students, exclude topics that are locked by module progression.
  #   Defaults to false.
  #
  # @example_request
  #     curl https://<canvas>/api/v1/courses/<course_id>/discussion_topics \
  #          -H 'Authorization: Bearer <token>'
  #
  # @returns [DiscussionTopic]
  def index
    include_params = Array(params[:include])
    page_has_instui_topnav
    if params[:only_announcements]
      return unless authorized_action(@context.announcements.temp_record, @current_user, :read)
    else
      return unless authorized_action(@context.discussion_topics.temp_record, @current_user, :read)

      if !api_request? && @context.is_a?(Course) && @context.horizon_course?
        redirect_to course_context_modules_path(@context.id)
        return
      end
    end

    return child_topic if is_child_topic?

    scope = if params[:only_announcements]
              @context.active_announcements
            else
              @context.active_discussion_topics.only_discussion_topics
            end

    # Specify the shard context, because downstream we use `union` which isn't
    # cross-shard compatible.
    @context.shard.activate do
      unless params[:only_announcements]
        scope = DiscussionTopic::ScopedToUser.new(@context, @current_user, scope).scope
      end
      # see context for this separation in ScopedToSections
      scope = DiscussionTopic::ScopedToSections.for(self, @context, @current_user, scope).scope
    end

    scope = if params[:order_by] == "recent_activity"
              scope.by_last_reply_at
            elsif params[:order_by] == "title"
              scope.order(DiscussionTopic.best_unicode_collation_key("discussion_topics.title")).ordered
            elsif params[:only_announcements]
              scope.by_posted_at
            else
              scope.by_position_legacy
            end

    scope = DiscussionTopic.search_by_attribute(scope, :title, params[:search_term])

    scope = scope.unread_for(@current_user) if params[:filter_by] == "unread"

    states = params[:scope].split(",").map(&:strip) if params[:scope]
    if states.present?
      if (states.include?("pinned") && states.include?("unpinned")) ||
         (states.include?("locked") && states.include?("unlocked"))
        render json: { errors: { scope: "scope is contradictory" } }, status: :bad_request
        return
      end

      if states.include?("pinned")
        scope = scope.where(pinned: true)
      elsif states.include?("unpinned")
        scope = scope.where("discussion_topics.pinned IS NOT TRUE")
      end
    end

    if params[:only_announcements] && !@context.grants_any_right?(@current_user, :manage, :read_as_admin)
      scope = scope.active.where("((unlock_at IS NULL AND delayed_post_at IS NULL) OR (unlock_at<? OR delayed_post_at<?)) AND ( lock_at IS NULL OR lock_at>?)", Time.now.utc, Time.now.utc, Time.now.utc)
    end

    per_page = params[:per_page] || 100

    @topics = []
    if @context.is_a?(Group) || request.format.json?
      @topics = Api.paginate(scope, self, topic_pagination_url, per_page:)
      if params[:exclude_context_module_locked_topics]
        ActiveRecord::Associations.preload(@topics, context_module_tags: :context_module)
        @topics = DiscussionTopic.reject_context_module_locked_topics(@topics, @current_user)
      end

      if states.present?
        @topics.reject! { |t| t.locked_for?(@current_user) } if states.include?("unlocked")
        @topics.select! { |t| t.locked_for?(@current_user) } if states.include?("locked")
      end
      @topics.each { |topic| topic.current_user = @current_user }
    end

    respond_to do |format|
      format.html do
        log_asset_access(["topics", @context], "topics", "other")

        set_active_tab "discussions"
        add_crumb(t("#crumbs.discussions", "Discussions"),
                  named_context_url(@context, :context_discussion_topics_url))

        if @context.is_a?(Group)
          ActiveRecord::Associations.preload(@topics, context_module_tags: :context_module)
          locked_topics, open_topics = @topics.partition do |topic|
            locked = topic.locked? || topic.locked_for?(@current_user)
            locked.is_a?(Hash) ? locked[:can_view] : locked
          end
          js_env openTopics: open_topics, lockedTopics: locked_topics, newTopicURL: named_context_url(@context, :new_context_discussion_topic_url)
        end

        fetch_params = {
          per_page:,
          plain_messages: true,
          include_assignment: true,
          exclude_assignment_descriptions: true,
          exclude_context_module_locked_topics: true,
          page: "__page__"
        }
        fetch_params[:include] = ["sections_user_count", "sections"] if @context.is_a?(Course)

        discussion_topics_fetch_url = send(:"api_v1_#{@context.class.to_s.downcase}_discussion_topics_path", fetch_params)
        (scope.count / fetch_params[:per_page].to_f).ceil.times do |i|
          url = discussion_topics_fetch_url.gsub(fetch_params[:page], (i + 1).to_s)
          prefetch_xhr(url, id: "prefetched_discussion_topic_page_#{i}")
        end

        feature_flags_url = case @context
                            when Course
                              context_url(@context, :context_settings_url, anchor: "tab-features")
                            when Group
                              ((@context.context&.is_a? Course) || (@context.context&.is_a? Account)) ? context_url(@context.context, :context_settings_url, anchor: "tab-features") : nil
                            else
                              nil
                            end

        assign_to_tags = @context.account.feature_enabled?(:assign_to_differentiation_tags) && @context.account.allow_assign_to_differentiation_tags?

        hash = {
          USER_SETTINGS_URL: api_v1_user_settings_url(@current_user),
          FEATURE_FLAGS_URL: feature_flags_url,
          ALLOW_ASSIGN_TO_DIFFERENTIATION_TAGS: assign_to_tags,
          CAN_MANAGE_DIFFERENTIATION_TAGS: @context.grants_any_right?(@current_user, session, *RoleOverride::GRANULAR_MANAGE_TAGS_PERMISSIONS),
          DISCUSSION_CHECKPOINTS_ENABLED: @context.discussion_checkpoints_enabled?,
          HAS_SIDE_COMMENT_DISCUSSIONS: Account.site_admin.feature_enabled?(:disallow_threaded_replies_fix_alert) ? @context.active_discussion_topics.only_discussion_topics.where(discussion_type: DiscussionTopic::DiscussionTypes::SIDE_COMMENT).exists? : false,
          AMOUNT_OF_SIDE_COMMENT_DISCUSSIONS: Account.site_admin.feature_enabled?(:disallow_threaded_replies_manage) ? @context.active_discussion_topics.only_discussion_topics.where(discussion_type: DiscussionTopic::DiscussionTypes::SIDE_COMMENT).count : 0,
          totalDiscussions: scope.count,
          permissions: {
            create: @context.discussion_topics.temp_record.grants_right?(@current_user, session, :create),
            moderate: user_can_moderate,
            change_settings: user_can_edit_course_settings?,
            manage_content: @context.grants_right?(@current_user, session, :manage_course_content_edit),
            publish: user_can_moderate,
            read_as_admin: @context.grants_right?(@current_user, session, :read_as_admin),
          },
          discussion_topic_menu_tools: external_tools_display_hashes(:discussion_topic_menu),
          student_reporting_enabled: @domain_root_account.feature_enabled?(:discussions_reporting),
          discussion_anonymity_enabled: @context.feature_enabled?(:react_discussions_post),
          discussion_topic_index_menu_tools: external_tools_display_hashes(:discussion_topic_index_menu),
          show_additional_speed_grader_links: Account.site_admin.feature_enabled?(:additional_speedgrader_links),
          PER_PAGE: per_page,
        }
        if @context.is_a?(Course) && @context.grants_right?(@current_user, session, :read) && @js_env&.dig(:COURSE_ID).blank?
          hash[:COURSE_ID] = @context.id.to_s
          set_section_list_js_env
          hash[:VALID_DATE_RANGE] = CourseDateRange.new(@context)
          hash[:HAS_GRADING_PERIODS] = @context.grading_periods?
        end
        conditional_release_js_env(includes: :active_rules)
        append_sis_data(hash)
        js_env(hash)
        set_tutorial_js_env

        if user_can_edit_course_settings?
          js_env(SETTINGS_URL: named_context_url(@context, :api_v1_context_settings_url))
        end

        @page_title = join_title(t("#titles.discussions", "Discussions"), @context.name)

        content_for_head helpers.auto_discovery_link_tag(:atom, feeds_forum_format_path(@context.feed_code, :atom), { title: t(:course_discussions_atom_feed_title, "Course Discussions Atom Feed") })

        js_bundle :discussion_topics_index
        css_bundle :discussions_index

        render html: "", layout: true
      end

      InstStatsd::Statsd.distributed_increment("discussion_topic.index.visit")
      InstStatsd::Statsd.count("discussion_topic.index.visit.pinned", @topics&.count(&:pinned))
      InstStatsd::Statsd.count("discussion_topic.index.visit.discussions", @topics&.length)
      InstStatsd::Statsd.count("discussion_topic.index.visit.closed_for_comments", @topics&.count(&:locked))

      format.json do
        log_api_asset_access(["topics", @context], "topics", "other")
        if @context.grants_right?(@current_user, session, :moderate_forum)
          mc_status = setup_master_course_restrictions(@topics, @context)
        end
        root_topic_fields = [:delayed_post_at, :lock_at]
        render json: discussion_topics_api_json(@topics,
                                                @context,
                                                @current_user,
                                                session,
                                                user_can_moderate:,
                                                plain_messages: value_to_boolean(params[:plain_messages]),
                                                exclude_assignment_description: value_to_boolean(params[:exclude_assignment_descriptions]),
                                                include_all_dates: include_params.include?("all_dates"),
                                                include_sections: include_params.include?("sections"),
                                                include_sections_user_count: include_params.include?("sections_user_count"),
                                                include_overrides: include_params.include?("overrides"),
                                                master_course_status: mc_status,
                                                root_topic_fields:)
      end
    end
  end

  def is_child_topic?
    root_topic_id = params[:root_discussion_topic_id]

    root_topic_id && @context.respond_to?(:context) &&
      @context.context&.discussion_topics&.find(root_topic_id)
  end

  def announcements_locked?
    return false unless @context.is_a?(Course)

    @context.lock_all_announcements?
  end

  def new
    @topic = @context.send(params[:is_announcement] ? :announcements : :discussion_topics).new
    page_has_instui_topnav

    edit
  end

  def edit
    @topic ||= @context.all_discussion_topics.find(params[:id])
    if !api_request? && @context.is_a?(Course) && @context.horizon_course? && !@topic.is_announcement
      redirect_to course_context_modules_path(@context.id)
      return
    end
    page_has_instui_topnav
    if @topic.root_topic_id && @topic.has_group_category?
      return redirect_to edit_course_discussion_topic_url(@context.context_id, @topic.root_topic_id)
    end

    return unless authorized_action(@topic, @current_user, (@topic.new_record? ? :create : :update))
    return render_unauthorized_action unless @topic.visible_for?(@current_user)

    @context.try(:require_assignment_group) unless @topic.is_announcement
    can_set_group = @context.respond_to?(:group_categories) && @context.grants_right?(@current_user, session, :manage_groups_add) # i.e. not a student
    hash = {
      URL_ROOT: named_context_url(@context, :api_v1_context_discussion_topics_url),
      PERMISSIONS: {
        CAN_CREATE_ASSIGNMENT: @context.respond_to?(:assignments) && @context.assignments.temp_record.grants_right?(@current_user, session, :create),
        CAN_UPDATE_ASSIGNMENT: @context.respond_to?(:assignments) && @context.assignments.temp_record.grants_right?(@current_user, session, :update),
        CAN_ATTACH: @topic.grants_right?(@current_user, session, :attach),
        CAN_MODERATE: user_can_moderate,
        CAN_SET_GROUP: can_set_group,
        CAN_EDIT_GRADES: can_do(@context, @current_user, :manage_grades),
        # if not a course content manager, or if topic is graded, do not show add to todo list checkbox
        CAN_MANAGE_CONTENT: @context.grants_right?(@current_user, session, :manage_course_content_add),
        CAN_MANAGE_ASSIGN_TO_GRADED: @context.discussion_topics.temp_record(assignment_id: 0).grants_right?(@current_user, session, @topic.new_record? ? :create_assign_to : :manage_assign_to),
        CAN_MANAGE_ASSIGN_TO_UNGRADED: @context.discussion_topics.temp_record(assignment_id: nil).grants_right?(@current_user, session, @topic.new_record? ? :create_assign_to : :manage_assign_to),
      }
    }

    usage_rights_required = @context.try(:usage_rights_required?)
    include_usage_rights = usage_rights_required
    course_published = if @context.is_a?(Course)
                         @context.published?
                       elsif @context.is_a?(Group) && @context.context.is_a?(Course)
                         @context.context.published?
                       else
                         # known case: @context.is_a?(Group) && @context.context&.is_a?(Account)
                         # at the time of writing, this is only used to show the announcment course unpublished warning
                         # so in this known case, and other unknown cases, we can just return true to not show the warning
                         true
                       end

    unless @topic.new_record?
      add_discussion_or_announcement_crumb
      add_crumb(@topic.title, named_context_url(@context, :context_discussion_topic_url, @topic.id))
      add_crumb t :edit_crumb, "Edit"
      hash[:ATTRIBUTES] = discussion_topic_api_json(
        @topic,
        @context,
        @current_user,
        session,
        override_dates: false,
        include_usage_rights:
      )

      hash[:ATTRIBUTES][:has_threaded_replies] = @topic.has_threaded_replies?
    end
    (hash[:ATTRIBUTES] ||= {})[:is_announcement] = @topic.is_announcement
    hash[:ATTRIBUTES][:can_group] = @topic.can_group?
    hash[:ATTRIBUTES][:course_published] = course_published
    handle_assignment_edit_params(hash[:ATTRIBUTES])

    categories = []
    if can_set_group && ANONYMOUS_STATES.exclude?(@topic.anonymous_state)
      categories = @context.group_categories.to_a
      # if discussion has entries and is attached to a deleted group category,
      # add that category to the ENV list so it will be shown on the edit page.
      if @topic.group_category_deleted_with_entries?
        categories << @topic.group_category
      end
    end

    if @topic.assignment.present?
      hash[:ATTRIBUTES][:assignment][:assignment_overrides] =
        assignment_overrides_json(
          @topic.assignment.overrides_for(@current_user, ensure_set_not_empty: true)
        )
      hash[:ATTRIBUTES][:assignment][:has_student_submissions] = @topic.assignment.has_student_submissions?
    end

    assign_to_tags = @context.account.feature_enabled?(:assign_to_differentiation_tags) && @context.account.allow_assign_to_differentiation_tags?

    js_hash = {
      ASSIGNMENT_ID: @topic.assignment_id,
      CONTEXT_ACTION_SOURCE: :discussion_topic,
      CONTEXT_ID: @context.id,
      GROUP_CONTEXT_TYPE: @context.is_a?(Group) ? @context.context.class.name : nil,
      DISCUSSION_TOPIC: hash,
      GROUP_CATEGORIES: categories
              .reject { |c| c.student_organized? || c.non_collaborative? }
              .map { |category| { id: category.id, name: category.name } },
      ALLOW_ASSIGN_TO_DIFFERENTIATION_TAGS: assign_to_tags,
      CAN_MANAGE_DIFFERENTIATION_TAGS: @context.grants_any_right?(@current_user, session, *RoleOverride::GRANULAR_MANAGE_TAGS_PERMISSIONS),
      HAS_GRADING_PERIODS: @context.grading_periods?,
      ANNOUNCEMENTS_LOCKED: announcements_locked?,
      CREATE_ANNOUNCEMENTS_UNLOCKED: @current_user.create_announcements_unlocked?,
      USAGE_RIGHTS_REQUIRED: usage_rights_required,
      IS_MODULE_ITEM: !@topic.context_module_tags.empty?,
      PERMISSIONS: {
        manage_files: @context.grants_any_right?(@current_user, session, *RoleOverride::GRANULAR_FILE_PERMISSIONS),
        manage_grading_schemes: can_do(@context, @current_user, :manage_grades)
      },
      REACT_DISCUSSIONS_POST: @context.feature_enabled?(:react_discussions_post),
      allow_student_anonymous_discussion_topics: @context.allow_student_anonymous_discussion_topics,
      context_is_not_group: !@context.is_a?(Group),
      GRADING_SCHEME_UPDATES_ENABLED: Account.site_admin.feature_enabled?(:grading_scheme_updates),
      ARCHIVED_GRADING_SCHEMES_ENABLED: Account.site_admin.feature_enabled?(:archived_grading_schemes),
      DISCUSSION_CHECKPOINTS_ENABLED: @context.discussion_checkpoints_enabled?,
      ASSIGNMENT_EDIT_PLACEMENT_NOT_ON_ANNOUNCEMENTS: Account.site_admin.feature_enabled?(:assignment_edit_placement_not_on_announcements),
      ANNOUNCEMENTS_COMMENTS_DISABLED: Announcement.new(context: @context).comments_disabled?,
      DISCUSSION_DEFAULT_EXPAND_ENABLED: true, # this is to avoid a small p4 on release
      DISCUSSION_DEFAULT_SORT_ENABLED: true, # this is to avoid a small p4 on release
      DISCUSSION_CONTENT_LOCKED: @topic.editing_restricted?(:content),
    }
    mutate_js_hash_sections_for_show_method(js_hash, @topic)

    post_to_sis = Assignment.sis_grade_export_enabled?(@context)
    js_hash[:POST_TO_SIS] = post_to_sis
    if post_to_sis && @topic.new_record?
      js_hash[:POST_TO_SIS_DEFAULT] = @context.account.sis_default_grade_export[:value]
    end
    js_hash[:STUDENT_PLANNER_ENABLED] =
      @context.grants_any_right?(@current_user, session, *RoleOverride::GRANULAR_MANAGE_COURSE_CONTENT_PERMISSIONS)

    js_hash[:SECTION_SPECIFIC_DISCUSSIONS_ENABLED] = !@context.is_a?(Group)
    js_hash[:MAX_NAME_LENGTH_REQUIRED_FOR_ACCOUNT] = AssignmentUtil.name_length_required_for_account?(@context)
    js_hash[:MAX_NAME_LENGTH] = AssignmentUtil.assignment_max_name_length(@context)
    js_hash[:DUE_DATE_REQUIRED_FOR_ACCOUNT] = AssignmentUtil.due_date_required_for_account?(@context)
    js_hash[:SIS_NAME] = AssignmentUtil.post_to_sis_friendly_name(@context)

    js_hash["VALID_DATE_RANGE"] = CourseDateRange.new(@context) if @context.is_a?(Course)

    js_hash[:CANCEL_TO] = cancel_redirect_url
    append_sis_data(js_hash)

    if @context.grading_periods?
      gp_context = @context.is_a?(Group) ? @context.context : @context
      js_hash[:active_grading_periods] = GradingPeriod.json_for(gp_context, @current_user)
    end
    if context.is_a?(Course)
      js_hash[:allow_self_signup] = true # for group creation
      js_hash[:group_user_type] = "student"
      append_default_due_time_js_env(@context, js_hash)
      js_hash[:COURSE_ID] = @context.id
      if Account.site_admin.feature_enabled?(:grading_scheme_updates)
        js_hash[:COURSE_DEFAULT_GRADING_SCHEME_ID] = @context.grading_standard_id || @context.default_grading_standard&.id
      end
      js_hash[:RESTRICT_QUANTITATIVE_DATA] = @context.settings[:restrict_quantitative_data]
    end

    if @context.root_account.feature_enabled?(:discussion_create) && @context.feature_enabled?(:react_discussions_post) && @context.grants_right?(@current_user, session, :read)
      js_hash[:context_id] = @context.id
      if @context.is_a?(Course)
        js_hash[:context_type] = "Course"
      elsif @context.is_a?(Group)
        js_hash[:context_type] = "Group"
      end
    end

    js_env(js_hash)

    set_master_course_js_env_data(@topic, @context)
    conditional_release_js_env(@topic.assignment)

    respond_to do |format|
      if @context.root_account.feature_enabled?(:discussion_create) && @context.feature_enabled?(:react_discussions_post)
        @page_title = topic_page_title(@topic)

        js_bundle :discussion_topic_edit_v2
        css_bundle :discussions_index, :learning_outcomes, :conditional_release_editor
        format.html do
          render html: "", layout: (params[:embed] == "true") ? "mobile_embed" : true
        end
      else
        format.html do
          render :edit, layout: (params[:embed] == "true") ? "mobile_embed" : true
        end
      end
    end
  end

  def show
    @topic = @context.all_discussion_topics.find(params[:id])
    if @context.is_a?(Course) && @context.horizon_course? && !@topic.is_announcement
      redirect_to course_context_modules_path(@context.id)
      return
    end
    page_has_instui_topnav
    # we still need the lock info even if the current user policies unlock the topic. check the policies manually later if you need to override the lockout.
    @locked = @topic.locked_for?(@current_user, check_policies: true, deep_check_if_needed: true)

    @context_module_tag = ContextModuleItem.find_tag_with_preferred([@topic, @topic.root_topic, @topic.assignment], params[:module_item_id])
    @sequence_asset = @context_module_tag.try(:content)
    add_discussion_or_announcement_crumb
    add_crumb(@topic.title, named_context_url(@context, :context_discussion_topic_url, @topic.id))
    @page_title = join_title(t("#titles.topic", "Topic"), @topic.title)

    if @topic.deleted?
      flash[:notice] = I18n.t :deleted_topic_notice, "That topic has been deleted"
      redirect_to named_context_url(@context, :context_discussion_topics_url)
      return
    end

    if @topic.anonymous? && !@context.feature_enabled?(:react_discussions_post)
      message = if @context.grants_right?(@current_user, session, :read_as_admin)
                  I18n.t(:anonymous_topic_notice_teacher, "Anonymous topics cannot be accessed without Discussions/Announcements Redesign feature preview enabled.")
                else
                  I18n.t(:anonymous_topic_notice_student, "Anonymous topics are not available at this time.")
                end
      flash[:info] = message
      redirect_to named_context_url(@context, :context_discussion_topics_url)
      return
    end

    if (can_read_and_visible = @topic.grants_right?(@current_user, session, :read) && @topic.visible_for?(@current_user))
      @topic.change_read_state("read", @current_user) unless @locked.is_a?(Hash) && !@locked[:can_view]
      add_rss_links_to_content
    end

    if (@context.is_a?(Course) || @context.is_a?(Group)) && @context.grants_right?(@current_user, session, :manage)
      set_student_context_cards_js_env
    end

    @presenter = DiscussionTopicPresenter.new(@topic, @current_user)
    can_attach_topic = @topic.grants_right?(@current_user, session, :attach)
    # Looking at the DiscussionEntry model, the policy for allowing to attach files to replies is
    # almost identical to the DiscussionTopic model, the code below adds the extra condition that
    # DiscussionEntry has but DiscussionTopic doesn't.
    can_attach_entries = can_attach_topic ||
                         (
                           @context.respond_to?(:allow_student_forum_attachments) &&
                           @context.allow_student_forum_attachments &&
                           @context.grants_right?(@current_user, session, :post_to_forum) &&
                           @topic.available_for?(@current_user)
                         )

    # Render updated Post UI if feature flag is enabled
    if @context.feature_enabled?(:react_discussions_post)
      env_hash = {
        per_page: 20,
        split_screen_view_initial_page_size: 5,
        current_page: 0
      }
      unless @context.is_a?(Group)
        env_hash[:context_rubric_associations_url] = context_url(@context, :context_rubric_associations_url)
        env_hash[:VALID_DATE_RANGE] = CourseDateRange.new(@context)
        env_hash[:HAS_GRADING_PERIODS] = @context.grading_periods?
        set_section_list_js_env
      end
      if params[:entry_id] && @topic.discussion_entries.find_by(id: params[:entry_id])
        entry = @topic.discussion_entries.find(params[:entry_id])
        env_hash[:discussions_deep_link] = {
          root_entry_id: entry.root_entry_id,
          parent_id: entry.parent_id,
          entry_id: entry.id
        }

        entry = entry.highest_level_parent_or_self
        sort_order = @topic.sort_order_for_user(@current_user)
        condition = (sort_order == DiscussionTopic::SortOrder::DESC) ? ">" : "<"
        count_before = @topic.root_discussion_entries
                             .where(parent_id: nil)
                             .where("created_at #{condition}?", entry.created_at).count
        env_hash[:current_page] = (count_before / env_hash[:per_page]).ceil

      end
      js_env(env_hash)

      topics = groups_and_group_topics if @topic.for_group_discussion?
      if topics && topics.length == 1 && !@topic.grants_right?(@current_user, session, :update)
        redirect_params = { root_discussion_topic_id: @topic.id }
        redirect_params[:module_item_id] = params[:module_item_id] if params[:module_item_id].present?
        # add in query parameters from the url, we want them preserved
        redirect_params.merge!(request.query_parameters) unless request.query_parameters.empty?
        redirect_to named_context_url(topics[0].context, :context_discussion_topics_url, redirect_params)
        return
      end
      log_asset_access(@topic, "topics", "topics")

      if @sequence_asset
        js_env({ SEQUENCE: {
                 ASSET_TYPE: @sequence_asset.is_a?(Assignment) ? "Assignment" : "Discussion",
                 ASSET_ID: @sequence_asset.id,
                 COURSE_ID: @sequence_asset.context.id,
               } })
      end

      @assignment_presenter = AssignmentPresenter.new(@topic.assignment)
      if @topic.for_assignment? && @presenter.allows_speed_grader? && @assignment_presenter.can_view_speed_grader_link?(@current_user)
        js_env(
          { SPEEDGRADER_URL_TEMPLATE: named_context_url(
            @topic.assignment.context,
            :speed_grader_context_gradebook_url,
            assignment_id: @topic.assignment.id,
            student_id: ":student_id"
          ) }
        )
      end

      unless can_read_and_visible
        return render_unauthorized_action unless @current_user

        respond_to do |format|
          if @topic.is_announcement
            flash[:error] = t "You do not have access to the requested announcement."
            format.html do
              redirect_to named_context_url(@context, :context_announcements_url)
              return
            end
          else
            flash[:error] = t "You do not have access to the requested discussion."
            format.html do
              redirect_to named_context_url(@context, :context_discussion_topics_url)
              return
            end
          end
        end
      end

      edit_url = context_url(@topic.context, :edit_context_discussion_topic_url, @topic)
      edit_url += "?embed=true" if params[:embed] == "true"

      assign_to_tags = @context.account.feature_enabled?(:assign_to_differentiation_tags) && @context.account.allow_assign_to_differentiation_tags?
      participant = @topic.participant(@current_user)
      translation_flags = Translation.get_translation_flags(@context.feature_enabled?(:translation), @domain_root_account)
      js_env({
               course_id: params[:course_id] || @context.course&.id,
               context_type: @topic.context_type,
               context_id: @context.id,
               EDIT_URL: edit_url,
               INSIGHTS_URL: context_url(@topic.context, :insights_context_discussion_topic_url, @topic),
               PEER_REVIEWS_URL: @topic.assignment ? context_url(@topic.assignment.context, :context_assignment_peer_reviews_url, @topic.assignment.id) : nil,
               ALLOW_ASSIGN_TO_DIFFERENTIATION_TAGS: assign_to_tags,
               CAN_MANAGE_DIFFERENTIATION_TAGS: @context.grants_any_right?(@current_user, session, *RoleOverride::GRANULAR_MANAGE_TAGS_PERMISSIONS),
               discussion_topic_id: @topic.id,
               manual_mark_as_read: @current_user&.manual_mark_as_read?,
               discussion_topic_menu_tools: external_tools_display_hashes(:discussion_topic_menu),
               rce_mentions_in_discussions: @context.feature_enabled?(:react_discussions_post) && !@topic.anonymous?,
               discussion_grading_view: Account.site_admin.feature_enabled?(:discussion_grading_view),
               draft_discussions: Account.site_admin.feature_enabled?(:draft_discussions),
               discussion_entry_version_history: Account.site_admin.feature_enabled?(:discussion_entry_version_history),
               discussion_translation_available: Translation.available?(translation_flags), # Is translation enabled on the course.
               ai_translation_improvements: @domain_root_account.feature_enabled?(:ai_translation_improvements),
               discussion_translation_languages: Translation.available?(translation_flags) ? Translation.languages(translation_flags) : [],
               discussion_anonymity_enabled: @context.feature_enabled?(:react_discussions_post),
               user_can_summarize: @topic.user_can_summarize?(@current_user),
               user_can_access_insights: @topic.user_can_access_insights?(@current_user),
               user_can_insights: user_can_moderate,
               discussion_pin_post: @context.feature_enabled?(:discussion_pin_post),
               discussion_summary_enabled: participant.nil? ? @topic.summary_enabled : participant.summary_enabled,
               should_show_deeply_nested_alert: @current_user&.should_show_deeply_nested_alert?,
               # although there is a permissions object in DiscussionEntry type, it's only accessible if a discussion entry
               # is being replied to. We need this env var so that replying to the topic can use this
               can_attach_entries:,
               # GRADED_RUBRICS_URL must be within DISCUSSION to avoid page error
               DISCUSSION: {
                 GRADED_RUBRICS_URL: (@topic.assignment ? context_url(@topic.assignment.context, :context_assignment_rubric_url, @topic.assignment.id) : nil),
                 CONTEXT_RUBRICS_URL: can_do(@topic.assignment, @current_user, :update) ? context_url(@topic.assignment.context, :context_rubrics_url) : "",
                 ATTACHMENTS_FOLDER_ID: @current_user.nil? ? Folder.unfiled_folder(@context).id : Folder.unfiled_folder(@current_user).id,
                 ASSIGNMENT: @topic.assignment&.asset_string,
                 preferences: {
                   discussions_splitscreen_view: @current_user&.discussions_splitscreen_view? || false
                 }
               },
               apollo_caching: @current_user &&
                 Account.site_admin.feature_enabled?(:apollo_caching),
               discussion_cache_key: @current_user &&
                 Base64.encode64("#{@current_user.uuid}vyfW=;[p-0?:{P_=HUpgraqe;njalkhpvoiulkimmaqewg"),
               checkpointed_discussion_without_feature_flag:
                 @topic.assignment&.has_sub_assignments? && !@context.discussion_checkpoints_enabled?,
               DISCUSSION_CHECKPOINTS_ENABLED: @context.discussion_checkpoints_enabled?,
               DISCUSSION_DEFAULT_EXPAND_ENABLED: true, # this is to avoid a small p4 on release
               DISCUSSION_DEFAULT_SORT_ENABLED: true, # this is to avoid a small p4 on release
             })
      unless @locked
        InstStatsd::Statsd.distributed_increment("discussion_topic.visit.redesign")
        InstStatsd::Statsd.count("discussion_topic.visit.entries.redesign", @topic.discussion_entries.count)
        InstStatsd::Statsd.count("discussion_topic.visit.pages.redesign", (@topic.discussion_entries.count / 20).ceil)
      end

      js_bundle :discussion_topics_post
      css_bundle :discussions_index, :learning_outcomes

      respond_to do |format|
        format.html do
          conditional_release_js_env(@topic.assignment)
          render html: "", layout: (params[:embed] == "true") ? "mobile_embed" : true
        end
      end

      return
    end

    @assignment = @topic.for_assignment? ? AssignmentOverrideApplicator.assignment_overridden_for(@topic.assignment, @current_user) : nil
    @context.try(:require_assignment_group)

    if can_read_and_visible
      @headers = !params[:headless]
      @unlock_at = @topic.available_from_for(@current_user)
      topics = groups_and_group_topics if @topic.for_group_discussion?

      @initial_post_required = @topic.initial_post_required?(@current_user, session)

      @padless = true

      log_asset_access(@topic, "topics", "topics")
      respond_to do |format|
        if topics && topics.length == 1 && !@topic.grants_right?(@current_user, session, :update)
          redirect_params = { root_discussion_topic_id: @topic.id }
          redirect_params[:module_item_id] = params[:module_item_id] if params[:module_item_id].present?
          format.html { redirect_to named_context_url(topics[0].context, :context_discussion_topics_url, redirect_params) }
        else
          format.html do
            @discussion_topic_menu_tools = external_tools_display_hashes(:discussion_topic_menu)

            if @context.is_a?(Course) && @topic.is_section_specific
              user_counts = Enrollment.where(course_section_id: @topic.course_sections,
                                             course_id: @context).not_fake.active_or_pending_by_date_ignoring_access
                                      .group(:course_section_id).count
              section_data = @topic.course_sections.map do |cs|
                cs.attributes.slice(*%w[id name]).merge(user_count: user_counts[cs.id] || 0)
              end
            end
            api_url = lambda do |endpoint, *params|
              endpoint = "api_v1_context_discussion_#{endpoint}_url"
              named_context_url(@context, endpoint, @topic, *params)
            end

            env_hash = {
              APP_URL: named_context_url(@context, :context_discussion_topic_url, @topic),
              TOPIC: {
                ID: @topic.id,
                TITLE: @topic.title,
                IS_SUBSCRIBED: @topic.subscribed?(@current_user),
                IS_PUBLISHED: @topic.published?,
                CAN_UNPUBLISH: @topic.can_unpublish?,
                IS_ANNOUNCEMENT: @topic.is_announcement,
                COURSE_SECTIONS: @topic.is_section_specific ? section_data : nil,
              },
              PERMISSIONS: {
                # Can reply
                CAN_REPLY: @topic.grants_right?(@current_user, session, :reply) &&
                           !@topic.homeroom_announcement?(@context),
                # Can attach files on topic
                CAN_ATTACH_TOPIC: can_attach_topic,
                # Can attach files on entries aka replies
                CAN_ATTACH_ENTRIES: can_attach_entries,
                CAN_RATE: @topic.grants_right?(@current_user, session, :rate),
                CAN_READ_REPLIES: @topic.grants_right?(@current_user, :read_replies) &&
                                  !@topic.homeroom_announcement?(@context),
                # Can moderate their own topics
                CAN_MANAGE_OWN: @context.user_can_manage_own_discussion_posts?(@current_user) &&
                                !@topic.locked_for?(@current_user, check_policies: true),
                # Can moderate any topic
                MODERATE: user_can_moderate
              },
              ROOT_URL: "#{api_url.call("topic_view")}?include_new_entries=1&include_enrollment_state=1&include_context_card_info=1",
              ENTRY_ROOT_URL: api_url.call("topic_entry_list"),
              REPLY_URL: api_url.call("add_reply", ":entry_id"),
              ROOT_REPLY_URL: api_url.call("add_entry"),
              DELETE_URL: api_url.call("delete_reply", ":id"),
              UPDATE_URL: api_url.call("update_reply", ":id"),
              MARK_READ_URL: api_url.call("topic_discussion_entry_mark_read", ":id"),
              MARK_UNREAD_URL: api_url.call("topic_discussion_entry_mark_unread", ":id"),
              RATE_URL: api_url.call("topic_discussion_entry_rate", ":id"),
              MARK_ALL_READ_URL: api_url.call("topic_mark_all_read"),
              MARK_ALL_UNREAD_URL: api_url.call("topic_mark_all_unread"),
              MANUAL_MARK_AS_READ: @current_user.try(:manual_mark_as_read?),
              CAN_SUBSCRIBE: !@topic.subscription_hold(@current_user, session),
              CURRENT_USER: user_display_json(@current_user),
              INITIAL_POST_REQUIRED: @initial_post_required,
              THREADED: @topic.threaded?,
              ALLOW_RATING: @topic.allow_rating,
              TODO_DATE: @topic.todo_date,
              IS_ASSIGNMENT: @topic.assignment_id?,
              ASSIGNMENT_ID: @topic.assignment_id,
              IS_GROUP: @topic.group_category_id?,
            }
            # will fire off the xhr for this as soon as the page comes back.
            # see ui/features/discussion_topic/backbone/models/Topic#fetch for where it is consumed
            prefetch_xhr(env_hash[:ROOT_URL])

            env_hash[:GRADED_RUBRICS_URL] = context_url(@topic.assignment.context, :context_assignment_rubric_url, @topic.assignment.id) if @topic.assignment
            if params[:hide_student_names]
              env_hash[:HIDE_STUDENT_NAMES] = true
              env_hash[:STUDENT_ID] = params[:student_id]
            end
            if @sequence_asset
              env_hash[:SEQUENCE] = {
                ASSET_TYPE: @sequence_asset.is_a?(Assignment) ? "Assignment" : "Discussion",
                ASSET_ID: @sequence_asset.id,
                COURSE_ID: @sequence_asset.context.id,
              }
            end
            @assignment_presenter = AssignmentPresenter.new(@topic.assignment)
            if @topic.for_assignment? && @presenter.allows_speed_grader? &&
               @assignment_presenter.can_view_speed_grader_link?(@current_user)
              env_hash[:SPEEDGRADER_URL_TEMPLATE] = named_context_url(@topic.assignment.context,
                                                                      :speed_grader_context_gradebook_url,
                                                                      assignment_id: @topic.assignment.id,
                                                                      student_id: ":student_id")
            end

            js_hash = { DISCUSSION: env_hash }
            if @context.is_a?(Course)
              GuardRail.activate(:secondary) do
                js_hash[:TOTAL_USER_COUNT] = @topic.context.enrollments.not_fake
                                                   .active_or_pending_by_date_ignoring_access.distinct.count(:user_id)
              end
            end
            js_hash[:COURSE_ID] = @context.id if @context.is_a?(Course)
            js_hash[:CONTEXT_ACTION_SOURCE] = :discussion_topic

            append_sis_data(js_hash)
            js_env(js_hash)
            set_master_course_js_env_data(@topic, @context)
            conditional_release_js_env(@topic.assignment, includes: [:rule])
            js_bundle :discussion_topic
            css_bundle :tinymce, :discussions, :learning_outcomes

            unless @locked
              InstStatsd::Statsd.distributed_increment("discussion_topic.visit.legacy")
              InstStatsd::Statsd.count("discussion_topic.visit.entries.legacy", @topic.discussion_entries.count)
              InstStatsd::Statsd.count("discussion_topic.visit.pages.legacy", (@topic.discussion_entries.count / 50).ceil)
            end

            render stream: can_stream_template?
          end
        end
      end
    else
      return render_unauthorized_action unless @current_user

      respond_to do |format|
        if @topic.is_announcement
          flash[:error] = t "You do not have access to the requested announcement."
          format.html { redirect_to named_context_url(@context, :context_announcements_url) }
        else
          flash[:error] = t "You do not have access to the requested discussion."
          format.html { redirect_to named_context_url(@context, :context_discussion_topics_url) }
        end
      end
    end
  end

  def insights
    @topic = @context.all_discussion_topics.find(params[:id])
    return render_unauthorized_action unless @topic.user_can_access_insights?(@current_user)

    add_discussion_or_announcement_crumb
    add_crumb(@topic.title, named_context_url(@context, :context_discussion_topic_url, @topic.id))
    add_crumb t(:insights_crumb, "Discussion Insights")
    @page_title = join_title("Discussion Insights", @topic.title)
    js_bundle :discussion_topic_insights
    js_env({
             course_id: params[:course_id] || @context.course&.id,
             context_type: @topic.context_type,
             context_id: @context.id,
             discussion_topic_id: @topic.id,
             INSIGHTS_URL: context_url(@topic.context, :insights_context_discussion_topic_url, @topic),
           })
    render html: "<div id='discussion-insights-container'/>".html_safe, layout: true
  end

  # @API Create a new discussion topic
  #
  # Create an new discussion topic for the course or group.
  #
  # @argument title [String]
  #
  # @argument message [String]
  #
  # @argument discussion_type [String, "side_comment"|"threaded"|"not_threaded"]
  #   The type of discussion. Defaults to side_comment or not_threaded if not value is given. Accepted values are 'side_comment', 'not_threaded' for discussions that only allow one level of nested comments, and 'threaded' for fully threaded discussions.
  #
  # @argument published [Boolean]
  #   Whether this topic is published (true) or draft state (false). Only
  #   teachers and TAs have the ability to create draft state topics.
  #
  # @argument delayed_post_at [DateTime]
  #   If a timestamp is given, the topic will not be published until that time.
  #
  # @argument allow_rating [Boolean]
  #   Whether or not users can rate entries in this topic.
  #
  # @argument lock_at [DateTime]
  #   If a timestamp is given, the topic will be scheduled to lock at the
  #   provided timestamp. If the timestamp is in the past, the topic will be
  #   locked.
  #
  # @argument podcast_enabled [Boolean]
  #   If true, the topic will have an associated podcast feed.
  #
  # @argument podcast_has_student_posts [Boolean]
  #   If true, the podcast will include posts from students as well. Implies
  #   podcast_enabled.
  #
  # @argument require_initial_post [Boolean]
  #   If true then a user may not respond to other replies until that user has
  #   made an initial reply. Defaults to false.
  #
  # @argument assignment [Assignment]
  #   To create an assignment discussion, pass the assignment parameters as a
  #   sub-object. See the {api:AssignmentsApiController#create Create an Assignment API}
  #   for the available parameters. The name parameter will be ignored, as it's
  #   taken from the discussion title. If you want to make a discussion that was
  #   an assignment NOT an assignment, pass set_assignment = false as part of
  #   the assignment object
  #
  # @argument is_announcement [Boolean]
  #   If true, this topic is an announcement. It will appear in the
  #   announcement's section rather than the discussions section. This requires
  #   announcment-posting permissions.
  #
  # @argument pinned [Boolean]
  #   If true, this topic will be listed in the "Pinned Discussion" section
  #
  # @argument position_after [String]
  #   By default, discussions are sorted chronologically by creation date, you
  #   can pass the id of another topic to have this one show up after the other
  #   when they are listed.
  #
  # @argument group_category_id [Integer]
  #   If present, the topic will become a group discussion assigned
  #   to the group.
  #
  # @argument only_graders_can_rate [Boolean]
  #   If true, only graders will be allowed to rate entries.
  #
  # @argument sort_order [String, "asc"|"desc"]
  #   Default sort order of the discussion. Accepted values are "asc", "desc".
  #
  # @argument sort_order_locked [Boolean]
  #   If true, users cannot choose their prefered sort order
  #
  # @argument expanded [Boolean]
  #   If true, thread will be expanded by default
  #
  # @argument expanded_locked [Boolean]
  #   If true, users cannot choose their prefered thread expansion setting
  #
  # @argument sort_by_rating [Boolean]
  #  (DEPRECATED) If true, entries will be sorted by rating.
  #
  # @argument attachment [File]
  #   A multipart/form-data form-field-style attachment.
  #   Attachments larger than 1 kilobyte are subject to quota restrictions.
  #
  # @argument specific_sections [String]
  #   A comma-separated list of sections ids to which the discussion topic
  #   should be made specific to.  If it is not desired to make the discussion
  #   topic specific to sections, then this parameter may be omitted or set to
  #   "all".  Can only be present only on announcements and only those that are
  #   for a course (as opposed to a group).
  #
  # @argument lock_comment [Boolean]
  #   If is_announcement and lock_comment are true, ‘Allow Participants to Comment’ setting is disabled.
  #
  # @example_request
  #     curl https://<canvas>/api/v1/courses/<course_id>/discussion_topics \
  #         -F title='my topic' \
  #         -F message='initial message' \
  #         -F podcast_enabled=1 \
  #         -H 'Authorization: Bearer <token>'
  #         -F 'attachment=@<filename>' \
  #
  # @example_request
  #     curl https://<canvas>/api/v1/courses/<course_id>/discussion_topics \
  #         -F title='my assignment topic' \
  #         -F message='initial message' \
  #         -F assignment[points_possible]=15 \
  #         -H 'Authorization: Bearer <token>'
  #
  def create
    page_has_instui_topnav
    process_discussion_topic(is_new: true)
  end

  # @API Update a topic
  #
  # Update an existing discussion topic for the course or group.
  #
  # @argument title [String]
  #
  # @argument message [String]
  #
  # @argument discussion_type [String, "side_comment"|"threaded"|"not_threaded"]
  #   The type of discussion. Defaults to side_comment or not_threaded if not value is given. Accepted values are 'side_comment', 'not_threaded' for discussions that only allow one level of nested comments, and 'threaded' for fully threaded discussions.
  #
  # @argument published [Boolean]
  #   Whether this topic is published (true) or draft state (false). Only
  #   teachers and TAs have the ability to create draft state topics.
  #
  # @argument delayed_post_at [DateTime]
  #   If a timestamp is given, the topic will not be published until that time.
  #
  # @argument lock_at [DateTime]
  #   If a timestamp is given, the topic will be scheduled to lock at the
  #   provided timestamp. If the timestamp is in the past, the topic will be
  #   locked.
  #
  # @argument podcast_enabled [Boolean]
  #   If true, the topic will have an associated podcast feed.
  #
  # @argument podcast_has_student_posts [Boolean]
  #   If true, the podcast will include posts from students as well. Implies
  #   podcast_enabled.
  #
  # @argument require_initial_post [Boolean]
  #   If true then a user may not respond to other replies until that user has
  #   made an initial reply. Defaults to false.
  #
  # @argument assignment [Assignment]
  #   To create an assignment discussion, pass the assignment parameters as a
  #   sub-object. See the {api:AssignmentsApiController#create Create an Assignment API}
  #   for the available parameters. The name parameter will be ignored, as it's
  #   taken from the discussion title. If you want to make a discussion that was
  #   an assignment NOT an assignment, pass set_assignment = false as part of
  #   the assignment object
  #
  # @argument is_announcement [Boolean]
  #   If true, this topic is an announcement. It will appear in the
  #   announcement's section rather than the discussions section. This requires
  #   announcment-posting permissions.
  #
  # @argument pinned [Boolean]
  #   If true, this topic will be listed in the "Pinned Discussion" section
  #
  # @argument position_after [String]
  #   By default, discussions are sorted chronologically by creation date, you
  #   can pass the id of another topic to have this one show up after the other
  #   when they are listed.
  #
  # @argument group_category_id [Integer]
  #   If present, the topic will become a group discussion assigned
  #   to the group.
  #
  # @argument allow_rating [Boolean]
  #   If true, users will be allowed to rate entries.
  #
  # @argument only_graders_can_rate [Boolean]
  #   If true, only graders will be allowed to rate entries.
  #
  # @argument sort_order [String, "asc"|"desc"]
  #   Default sort order of the discussion. Accepted values are "asc", "desc".
  #
  # @argument sort_order_locked [Boolean]
  #   If true, users cannot choose their prefered sort order
  #
  # @argument expanded [Boolean]
  #   If true, thread will be expanded by default
  #
  # @argument expanded_locked [Boolean]
  #   If true, users cannot choose their prefered thread expansion setting
  #
  # @argument sort_by_rating [Boolean]
  #   (DEPRECATED) If true, entries will be sorted by rating.
  #
  # @argument specific_sections [String]
  #   A comma-separated list of sections ids to which the discussion topic
  #   should be made specific too.  If it is not desired to make the discussion
  #   topic specific to sections, then this parameter may be omitted or set to
  #   "all".  Can only be present only on announcements and only those that are
  #   for a course (as opposed to a group).
  #
  # @argument lock_comment [Boolean]
  #   If is_announcement and lock_comment are true, ‘Allow Participants to Comment’ setting is disabled.
  #
  # @example_request
  #     curl https://<canvas>/api/v1/courses/<course_id>/discussion_topics/<topic_id> \
  #         -F title='This will be positioned after Topic #1234' \
  #         -F position_after=1234 \
  #         -H 'Authorization: Bearer <token>'
  #
  def update
    process_discussion_topic(is_new: false)
  end

  # @API Delete a topic
  #
  # Deletes the discussion topic. This will also delete the assignment, if it's
  # an assignment discussion.
  #
  # @example_request
  #     curl -X DELETE https://<canvas>/api/v1/courses/<course_id>/discussion_topics/<topic_id> \
  #          -H 'Authorization: Bearer <token>'
  def destroy
    @topic = @context.all_discussion_topics.find(params[:id] || params[:topic_id])
    if authorized_action(@topic, @current_user, :delete)
      return render_unauthorized_action if editing_restricted?(@topic)

      @topic.destroy
      respond_to do |format|
        format.html do
          flash[:notice] = t :topic_deleted_notice, "%{topic_title} deleted successfully", topic_title: @topic.title
          redirect_to named_context_url(@context, @topic.is_announcement ? :context_announcements_url : :context_discussion_topics_url)
        end
        format.json { render json: @topic.as_json(include: { user: { only: :name } }), status: :ok }
      end
    end
  end

  def public_feed
    return unless get_feed_context

    title = t :discussion_feed_title, "%{title} Discussion Feed", title: @context.name
    link = polymorphic_url([@context, :discussion_topics])

    @entries = []
    @entries.concat(@context.discussion_topics
                            .select { |dt| dt.visible_for?(@current_user) })
    @entries.concat @context.discussion_entries.active
    @entries = @entries.sort_by(&:updated_at)

    respond_to do |format|
      format.atom { render plain: AtomFeedHelper.render_xml(title:, link:, entries: @entries) }
    end
  end

  # @API Reorder pinned topics
  #
  # Puts the pinned discussion topics in the specified order.
  # All pinned topics should be included.
  #
  # @argument order[] [Required, Integer]
  #   The ids of the pinned discussion topics in the desired order.
  #   (For example, "order=104,102,103".)
  #
  def reorder
    if authorized_action(@context.discussion_topics.temp_record, @current_user, :update)
      order = Api.value_to_array(params[:order])
      reject! "order parameter required" unless order.present?
      topics = pinned_topics.where(id: order)
      reject! "topics not found" unless topics.length == order.length
      topics[0].update_order(order)
      new_order = pinned_topics.by_position.pluck(:id).map(&:to_s)
      render json: { reorder: true, order: new_order }, status: :ok
    end
  end

  protected

  def cancel_redirect_url
    query_params = request.query_parameters.empty? ? {} : request.query_parameters
    topic_type = @topic.is_announcement ? :announcements : :discussion_topics
    @topic.new_record? ? polymorphic_url([@context, topic_type], query_params) : polymorphic_url([@context, @topic], query_params)
  end

  def pinned_topics
    @context.active_discussion_topics.only_discussion_topics.where(pinned: true)
  end

  def add_discussion_or_announcement_crumb
    if @topic.is_a? Announcement
      set_active_tab "announcements"
      add_crumb t("#crumbs.announcements", "Announcements"), named_context_url(@context, :context_announcements_url)
    else
      set_active_tab "discussions"
      add_crumb t("#crumbs.discussions", "Discussions"), named_context_url(@context, :context_discussion_topics_url)
    end
  end

  def user_can_moderate
    @user_can_moderate = @context.grants_right?(@current_user, session, :moderate_forum) if @user_can_moderate.nil?
    @user_can_moderate
  end

  API_ALLOWED_TOPIC_FIELDS = %w[title
                                message
                                discussion_type
                                delayed_post_at
                                lock_at
                                podcast_enabled
                                podcast_has_student_posts
                                require_initial_post
                                pinned
                                todo_date
                                group_category_id
                                allow_rating
                                only_graders_can_rate
                                sort_by_rating
                                anonymous_state
                                is_anonymous_author].freeze

  API_ALLOWED_TOPIC_FIELDS_FOR_GROUP = %w[title
                                          message
                                          discussion_type
                                          podcast_enabled
                                          pinned
                                          todo_date
                                          allow_rating
                                          only_graders_can_rate
                                          sort_by_rating
                                          anonymous_state
                                          is_anonymous_author].freeze

  def set_sections
    if params[:specific_sections] == "all"
      @topic.is_section_specific = false
    else
      @topic.is_section_specific = true
      section_ids = params[:specific_sections]
      section_ids = section_ids.split(",") if section_ids.is_a?(String)
      new_section_ids = section_ids.map { |id| Shard.relative_id_for(id, Shard.current, Shard.current) }.sort
      if @topic.course_sections.pluck(:id).sort != new_section_ids
        @topic.course_sections = CourseSection.find(new_section_ids)
        @topic.sections_changed = true
      end
    end
  end

  def verify_specific_section_visibilities
    return unless @topic.is_section_specific && @context.is_a?(Course)

    visibilities = @context.course_section_visibility(@current_user)

    invalid_sections =
      case visibilities
      when :all
        []
      when :none
        @topic.course_sections.map(&:id)
      else
        @topic.course_sections.map(&:id) - visibilities
      end

    unless invalid_sections.empty?
      @errors[:specific_sections] = t(
        :error_section_permission,
        "You do not have permissions to modify discussion for section(s) %{section_ids}",
        section_ids: invalid_sections.join(", ")
      )
    end
  end

  def process_discussion_topic(is_new:)
    ActiveRecord::Base.transaction do
      process_discussion_topic_runner(is_new:)
    end
  end

  def process_discussion_topic_runner(is_new:)
    @errors = {}
    if is_new && !@context.feature_enabled?(:react_discussions_post)
      params[:anonymous_state] = nil
    end

    # only full_anonymity and partial_anonymity can be stored. the rest will be nil'ed out
    if is_new && params[:anonymous_state].present? && ANONYMOUS_STATES.exclude?(params[:anonymous_state])
      params[:anonymous_state] = nil
    end

    if params[:anonymous_state]
      # group discussions in a course or discussions simply in a group context cannot be anonymous
      if params[:group_category_id] || @context.is_a?(Group)
        @errors[:anonymous_state] = t(:error_anonymous_state_groups_create, "Group discussions cannot be anonymous.") unless params.key?("group_category_id") && params[:group_category_id].nil?
      end
      if params[:assignment] && (["false", false, "0"].include?(params.dig(:assignment, :set_assignment)) == false)
        @errors[:anonymous_state] = t(:error_graded_anonymous,
                                      "Anonymous discussions cannot be graded")
      end
    end

    attachment = params[:attachment]

    if is_new && attachment
      get_quota(@context)
      if attachment.size + @quota_used > @quota
        error = t "#application.errors.quota_exceeded_course", "Course storage quota exceeded"
        respond_to do |format|
          format.json { render json: { errors: { base: error } }, status: :bad_request }
        end
        return
      end
    end

    # Groups do not have settings like courses do, so only run this for Course contexts
    if is_new &&
       !params[:anonymous_state].nil? &&
       @context.is_a?(Course) &&
       !@context.settings[:allow_student_anonymous_discussion_topics] &&
       !@context.grants_right?(@current_user, session, :manage)
      @errors[:anonymous_state] = t(:error_anonymous_state_unauthorized_create,
                                    "You are not able to create an anonymous discussion")
    end

    model_type = if value_to_boolean(params[:is_announcement]) &&
                    @context.announcements.temp_record.grants_right?(@current_user, session, :create)
                   :announcements
                 else
                   :discussion_topics
                 end

    if is_new
      @topic = @context.send(model_type).build
      prior_version = @topic.dup
      if model_type == :announcements && @context.is_a?(Course)
        @topic.locked = true
        save_lock_preferences
      end
    else
      @topic = @context.send(model_type).active.find(params[:id] || params[:topic_id])

      prior_version = DiscussionTopic.find(@topic.id)
      if params.include?(:anonymous_state) && prior_version.anonymous_state != params[:anonymous_state] && prior_version.discussion_subentry_count > 0
        @errors[:anonymous_state] = { "message" => t(:error_anonymous_state_unauthorized_update,
                                                     "Anonymity settings are locked due to a posted reply") }
      end
      if ANONYMOUS_STATES.include?(@topic.anonymous_state) && params[:group_category_id]
        @errors[:anonymous_state] = t(:error_anonymous_state_groups_update,
                                      "Group discussions cannot be anonymous.")
      end
      verify_specific_section_visibilities # Make sure user actually has perms to modify this
    end

    if params.include?(:assignment)
      if is_new || @topic.assignment_id.nil?
        return unless authorized_action(@context.assignments.temp_record, @current_user, :create)
      else
        return unless authorized_action(@topic.assignment, @current_user, :update)
      end
    end

    # It's possible customers already are using this API and haven't updated to
    # use the `specific_sections` key yet. In this case, we don't want to nuke
    # any specific setions out from under them when their existing scrit runs.
    # This is where a versioned API would come in handy.
    set_sections if params[:specific_sections]
    verify_specific_section_visibilities

    allowed_fields = @context.is_a?(Group) ? API_ALLOWED_TOPIC_FIELDS_FOR_GROUP : API_ALLOWED_TOPIC_FIELDS
    discussion_topic_hash = params.permit(*allowed_fields)
    only_pinning = discussion_topic_hash.except(*%w[pinned]).blank?

    # Handle the locked parameter
    if @topic.is_announcement
      params[:locked] = if params[:lock_comment].present?
                          value_to_boolean(params[:lock_comment])
                        elsif params[:locked].present?
                          value_to_boolean(params[:locked])
                        else
                          false
                        end
    end

    if @topic.is_announcement && params[:locked]
      discussion_topic_hash.delete(:discussion_type)
      discussion_topic_hash.delete(:require_initial_post)
    end

    # allow pinning/unpinning if a subtopic and we can update the root
    topic_to_check = (only_pinning && @topic.root_topic) ? @topic.root_topic : @topic
    return unless authorized_action(topic_to_check, @current_user, (is_new ? :create : :update))

    process_podcast_parameters(discussion_topic_hash)

    if is_new
      @topic.user = @current_user
    elsif !only_pinning # don't update editor if the only thing that changed was the pinned status
      @topic.editor = @current_user
    end
    @topic.current_user = @current_user
    @topic.content_being_saved_by(@current_user)

    if discussion_topic_hash.key?(:message)
      discussion_topic_hash[:message] = process_incoming_html_content(discussion_topic_hash[:message])
    end

    @topic.sort_order_locked = params[:sort_order_locked] unless params[:sort_order_locked].nil?
    unless params[:sort_order].nil?
      if DiscussionTopic::SortOrder::TYPES.include?(params[:sort_order])
        @topic.sort_order = params[:sort_order]
      else
        @errors[:sort_order] = t(:error_sort_order,
                                 "Sort order type not valid")
      end

    end

    @topic.expanded = params[:expanded] unless params[:expanded].nil?
    @topic.expanded_locked = params[:expanded_locked] unless params[:expanded_locked].nil?

    prefer_assignment_availability_dates(discussion_topic_hash)

    process_future_date_parameters(discussion_topic_hash)
    process_lock_parameters(discussion_topic_hash)

    process_published_parameters
    if is_new && @topic.published? && params[:assignment]
      @topic.unpublish
      @topic.root_topic.try(:unpublish)
      publish_later = true
    end

    process_group_parameters(discussion_topic_hash)
    process_pin_parameters
    process_todo_parameters

    if @errors.present?
      render json: { errors: @errors }, status: :bad_request
    else
      @topic.skip_broadcasts = true
      DiscussionTopic.transaction do
        if @topic.is_section_specific
          # HACK: For some reason apply_assignment_parameters saves the submittable
          # so we can't run it until everything is already good.  But if the topic
          # is section specific stuff isn't good until we clear out the assignment,
          # so do that here.  This is terrible.
          if params[:assignment] && !value_to_boolean(params[:assignment][:set_assignment])
            @topic.assignment = nil
          end
        else
          @topic.course_sections = []
        end
        @topic.update(discussion_topic_hash)
        @topic.root_topic.try(:save)
      end
      if @topic.errors.none? && !@topic.root_topic.try(:errors).try(:any?)
        log_asset_access(@topic, "topics", "topics", "participate")

        apply_positioning_parameters
        apply_attachment_parameters
        unless @topic.root_topic_id?
          apply_assignment_parameters(params[:assignment], @topic)
        end

        if publish_later
          @topic.publish!
          @topic.root_topic.try(:publish!)
        end

        @topic = DiscussionTopic.find(@topic.id)
        @topic.broadcast_notifications(prior_version)

        include_usage_rights = @context.try(:usage_rights_required?)

        if is_new
          InstStatsd::Statsd.distributed_increment("discussion_topic.created")

          if params[:podcast_enabled] == "1"
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.podcast_feed_enabled")
          end

          if params[:allow_rating] == "1"
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.allow_liking_enabled")
          end

          if params[:attachment]
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.attachment")
          end

          if !params[:delayed_post_at]&.empty? || !params[:lock_at]&.empty?
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.scheduled")
          end

          if params[:anonymous_state] == "partial_anonymity"
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.partial_anonymity")
          end

          if params[:anonymous_state] == "full_anonymity"
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.full_anonymity")
          end

          if params[:assignment]
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.graded")
          end

          if @context.is_a?(Group)
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.group")
          end

          if request.params[:assignment] && request.params[:assignment][:assignment_overrides] && request.params[:assignment][:assignment_overrides].length > 1
            InstStatsd::Statsd.distributed_increment("discussion_topic.created.multiple_due_dates")
          end
        end

        if @context.is_a?(Course)
          render json: discussion_topic_api_json(@topic,
                                                 @context,
                                                 @current_user,
                                                 session,
                                                 {
                                                   include_sections: true,
                                                   include_sections_user_count: true,
                                                   include_usage_rights:
                                                 })
        else
          render json: discussion_topic_api_json(@topic,
                                                 @context,
                                                 @current_user,
                                                 session,
                                                 {
                                                   include_usage_rights:
                                                 })
        end
      else
        errors = @topic.errors.as_json[:errors]
        errors.merge!(@topic.root_topic.errors.as_json[:errors]) if @topic.root_topic
        errors["published"] = errors.delete(:workflow_state) if errors.key?(:workflow_state)
        render json: { errors: }, status: :bad_request
      end
    end
  end

  def process_podcast_parameters(discussion_topic_hash)
    discussion_topic_hash[:podcast_enabled] = true if value_to_boolean(discussion_topic_hash[:podcast_has_student_posts])

    unless user_can_moderate
      discussion_topic_hash.delete :podcast_enabled
      discussion_topic_hash.delete :podcast_has_student_posts
    end
  end

  def process_todo_parameters
    remove_assign = ["false", false, "0"].include?(params.dig(:assignment, :set_assignment))
    if params[:assignment] && !remove_assign && !params[:todo_date]
      @topic.todo_date = nil
      return
    end
    return unless params[:todo_date]

    if !authorized_action(@topic.context, @current_user, :manage_course_content_add)
      @errors[:todo_date] = t(:error_todo_date_unauthorized,
                              "You do not have permission to add this topic to the student to-do list.")
    elsif (@topic.assignment || params[:assignment]) && !remove_assign
      @errors[:todo_date] = t(:error_todo_date_assignment, "Date cannot be added if discussion topic is graded")
    end
  end

  def prefer_assignment_availability_dates(discussion_topic_hash)
    return unless params[:assignment]

    discussion_topic_hash["delayed_post_at"] = nil if params[:assignment].key?(:unlock_at)
    discussion_topic_hash["lock_at"] = nil if params[:assignment].key?(:lock_at)
  end

  # Internal: detetermines if the delayed_post_at or lock_at dates were changed
  # and applies changes to the topic if they were.
  #
  # Returns true if dates were changed and the topic was updated, false otherwise.
  def process_future_date_parameters(discussion_topic_hash)
    # Set the delayed_post_at and lock_at if provided. This will be used to determine if the values have changed
    # in order to know if we should rely on this data to update the workflow state
    @topic.delayed_post_at = discussion_topic_hash[:delayed_post_at] if params.key? :delayed_post_at
    if discussion_topic_hash[:lock_at].present? && @topic&.lock_at&.to_i == Time.zone.parse(discussion_topic_hash[:lock_at]).to_i
      params.delete(:lock_at)
    end
    @topic.lock_at = discussion_topic_hash[:lock_at] if params.key? :lock_at

    if @topic.unlock_at_changed? || @topic.delayed_post_at_changed? || @topic.lock_at_changed?
      @topic.workflow_state = @topic.should_not_post_yet ? "post_delayed" : "active"
      if @topic.should_lock_yet
        @topic.lock(without_save: true)
      else
        @topic.unlock(without_save: true)
      end
    end
  end

  def save_lock_preferences
    return if @current_user.nil?
    return if !params.key?(:locked) || params[:locked].is_a?(Hash)

    should_lock = value_to_boolean(params[:locked])
    @current_user.create_announcements_unlocked(!should_lock)
    @current_user.save
  end

  def process_lock_parameters(discussion_topic_hash)
    # Handle locking/unlocking (overrides workflow state if provided). It appears that the locked param as a hash
    # is from old code and is not being used. Verification requested.
    if !@topic.lock_at_changed? && params.key?(:locked) && !params[:locked].is_a?(Hash)
      should_lock = value_to_boolean(params[:locked])
      if should_lock != @topic.locked?
        if should_lock
          @topic.lock(without_save: true)
        else
          discussion_topic_hash[:lock_at] = nil
          @topic.unlock(without_save: true)
        end
      end
    end
  end

  def process_published_parameters
    if params.key?(:published)
      should_publish = value_to_boolean(params[:published])
      if should_publish != @topic.published?
        if should_publish
          @topic.publish
          @topic.root_topic.try(:publish)
        elsif user_can_moderate
          @topic.unpublish
          @topic.root_topic.try(:unpublish)
        else
          @errors[:published] = t(:error_draft_state_unauthorized, "You do not have permission to set this topic to draft state.")
        end
      end
    elsif @topic.new_record? && !@topic.is_announcement && user_can_moderate
      @topic.unpublish
    end
  end

  def process_group_parameters(discussion_topic_hash)
    if params[:assignment]&.key?(:group_category_id)
      id = params[:assignment].delete(:group_category_id)
      discussion_topic_hash[:group_category_id] ||= id
    end
    return unless discussion_topic_hash.key?(:group_category_id)
    return if discussion_topic_hash[:group_category_id].nil? && @topic.group_category_id.nil?
    return if discussion_topic_hash[:group_category_id].to_i == @topic.group_category_id
    return unless can_set_group_category?

    discussion_topic_hash[:group_category] = if discussion_topic_hash[:group_category_id]
                                               @context.group_categories.find(discussion_topic_hash[:group_category_id])
                                             else
                                               nil
                                             end
  end

  def can_set_group_category?
    error =
      if !@context.grants_right?(@current_user, session, :manage_groups_add)
        t("You cannot set a grouped discussion as a student.")
      elsif @topic.is_announcement
        t(:error_group_announcement, "You cannot use grouped discussion on an announcement.")
      elsif !@topic.can_group?
        t(:error_group_change, "You cannot change grouping on a discussion with replies.")
      end
    @errors[:group] = error if error
    !error
  end

  # TODO: upgrade acts_as_list after rails3
  # check_scope will probably handle this
  def process_pin_parameters
    return unless params.key?(:pinned)

    pinned = value_to_boolean(params[:pinned])
    return unless pinned != @topic.pinned?

    @topic.pinned = pinned
    @topic.position = nil
    @topic.add_to_list_bottom
  end

  def apply_positioning_parameters
    if params[:position_after] && user_can_moderate
      other_topic = @context.discussion_topics.active.find(params[:position_after])
      @topic.insert_at(other_topic.position)
    end

    if params[:position_at] && user_can_moderate
      @topic.insert_at(params[:position_at].to_i)
    end
  end

  def apply_attachment_parameters
    # handle creating/removing attachment
    if @topic.grants_right?(@current_user, session, :attach)
      attachment = params[:attachment].present? &&
                   params[:attachment]

      return if attachment && attachment.size > 1.kilobyte &&
                quota_exceeded(@context, named_context_url(@context, :context_discussion_topics_url))

      if (params.key?(:remove_attachment) || attachment) && @topic.attachment
        @topic.transaction do
          att = @topic.attachment
          @topic.attachment = nil
          @topic.save! unless @topic.new_record?
          att.destroy
        end
      end

      if attachment
        @attachment = @context.attachments.new
        Attachments::Storage.store_for_attachment(@attachment, attachment)
        set_default_usage_rights(@attachment)
        @attachment.save!
        @attachment.handle_duplicates(:rename)
        @topic.attachment = @attachment
        @topic.save
      end
    end
  end

  def set_default_usage_rights(attachment)
    return unless @context.try(:usage_rights_required?)
    return if @context.grants_any_right?(@current_user, session, *RoleOverride::GRANULAR_FILE_PERMISSIONS)

    attachment.usage_rights = @context.usage_rights.find_or_create_by(
      use_justification: "own_copyright",
      legal_copyright: ""
    )
  end

  def child_topic
    extra_params = {}
    if params[:headless]
      extra_params.merge(
        headless: 1,
        hide_student_names: params[:hide_student_names],
        student_id: params[:student_id]
      )
    end
    extra_params[:module_item_id] = params[:module_item_id] if params[:module_item_id].present?
    extra_params[:embed] = params[:embed] if params[:embed].present?
    extra_params[:display] = params[:display] if params[:display].present?
    extra_params[:session_timezone] = params[:session_timezone] if params[:session_timezone].present?
    extra_params[:session_locale] = params[:session_locale] if params[:session_locale].present?

    @root_topic = @context.context.discussion_topics.find(params[:root_discussion_topic_id])
    @topic = @root_topic.ensure_child_topic_for(@context)
    redirect_to named_context_url(@context, :context_discussion_topic_url, @topic.id, extra_params)
  end

  def user_can_edit_course_settings?
    @context.is_a?(Course) && @context.grants_right?(@current_user, session, :update)
  end

  def handle_assignment_edit_params(hash)
    hash[:title] = params[:title] if params[:title]
    if params.slice(:due_at, :points_possible, :assignment_group_id).present?
      if hash[:assignment].nil? && @context.respond_to?(:assignments) && @context.assignments.temp_record.grants_right?(@current_user, session, :create)
        hash[:assignment] ||= {}
      end

      unless hash[:assignment].nil?
        if params[:due_at]
          hash[:assignment][:due_at] = (params[:due_at].empty? || params[:due_at] == "null") ? nil : params[:due_at]
        end
        hash[:assignment][:points_possible] = params[:points_possible] if params[:points_possible]
        hash[:assignment][:assignment_group_id] = params[:assignment_group_id] if params[:assignment_group_id]
      end
    end
  end

  private

  def add_rss_links_to_content
    rss_context = @context_enrollment
    rss_context ||= @context if @context.available?
    if rss_context
      content_for_head helpers.auto_discovery_link_tag(:atom,
                                                       feeds_topic_format_path(@topic.id, rss_context.feed_code, :atom),
                                                       { title: t(:discussion_atom_feed_title, "Discussion Atom Feed") })
      if @topic.podcast_enabled
        content_for_head helpers.auto_discovery_link_tag(:rss,
                                                         feeds_topic_format_path(@topic.id, rss_context.feed_code, :rss),
                                                         { title: t(:discussion_podcast_feed_title, "Discussion Podcast Feed") })
      end
    end
  end

  def groups_and_group_topics
    @groups = @topic.group_category.groups.active
    if @topic.for_assignment? && @topic.assignment.only_visible_to_overrides?
      override_groups = @groups.joins("INNER JOIN #{AssignmentOverride.quoted_table_name}
            ON assignment_overrides.set_type = 'Group' AND assignment_overrides.set_id = groups.id")
                               .merge(AssignmentOverride.active)
                               .where(assignment_overrides: { assignment_id: @topic.assignment_id })
      @groups = override_groups if override_groups.present?
    end
    topics = @topic.child_topics
    unless @context.grants_right?(@current_user, session, :read_as_admin)
      @groups = @groups.joins(:group_memberships).merge(GroupMembership.active).where(group_memberships: { user_id: @current_user })
      topics = topics.where(context_type: "Group", context_id: @groups)
    end

    @group_topics = @groups.order(:id).map do |group|
      { group:, topic: topics.find { |t| t.context == group } }
    end
    topics
  end

  def set_section_list_js_env
    # TODO: Replace this with Course#sections_visible_to
    section_visibilities =
      if @context.respond_to?(:course_section_visibility)
        @context.course_section_visibility(@current_user)
      else
        :none
      end

    sections =
      case section_visibilities
      when :none
        []
      when :all
        @context.course_sections.active.to_a
      else
        @context.course_sections.select { |s| s.active? && section_visibilities.include?(s.id) }
      end

    js_env SECTION_LIST: sections.map { |section|
      {
        id: section.id,
        name: section.name,
        start_at: section.start_at,
        end_at: section.end_at,
        override_course_and_term_dates: section.restrict_enrollments_to_section_dates
      }
    }
  end

  def mutate_js_hash_sections_for_show_method(js_hash, topic)
    # TODO: Replace this with Course#sections_visible_to taking into account Groups as well

    section_visibilities =
      if @context.respond_to?(:course_section_visibility)
        # Course.course_section_visibility can also return :none
        @context.course_section_visibility(@current_user)
      else
        :none
      end

    sections =
      case section_visibilities
      when :none
        []
      when :all
        @context.course_sections.active.order(:name).to_a
      else
        @context.course_sections.active.order(:name).select { |s| section_visibilities.include?(s.id) }
      end

    js_hash[:SECTION_LIST] = sections.map { |section| { id: section.id, name: section.name } } if @context.is_a?(Group)

    if @context.is_a?(Course)
      js_hash[:SECTION_LIST] = sections.map do |section|
        {
          id: section.id,
          name: section.name,
          start_at: section.start_at,
          end_at: section.end_at,
          override_course_and_term_dates: section.restrict_enrollments_to_section_dates
        }
      end
      js_hash[:USER_HAS_RESTRICTED_VISIBILITY] = section_visibilities != :all

      if topic.is_section_specific
        selected_section_ids = topic.discussion_topic_section_visibilities.pluck(:course_section_id)
        js_hash[:SELECTED_SECTION_LIST] = sections.select { |s| selected_section_ids.include?(s.id) }.map do |section|
          {
            id: section.id,
            name: section.name
          }
        end
      end
    end
  end
end
