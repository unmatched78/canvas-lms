# frozen_string_literal: true

#
# Copyright (C) 2016 - present Instructure, Inc.
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
#

require_relative "../common"

shared_context "discussions_page_shared_context" do
  let(:unauthorized_message) { "#unauthorized_message" }
  let(:course_page) { "/courses/#{@course.id}" }
  let(:discussions_topic_page) { "/courses/#{@course.id}/discussion_topics" }
  let(:discussions_topic_detail_page) { "/courses/#{@course.id}/discussion_topics/#{@discussion_topic.id}" }
  let(:permissions_page) { "/account/#{@account.id}/permissions" }
  let(:discussion_link) { ".discussions" }
  let(:discussion_message) { '[data-resource-type="discussion_topic.body"]:contains("Discussion 1 message")' }
  let(:discussion_edit_button) { '[data-testid="discussion-thread-menuitem-edit"]' }
  let(:course_navigation_items) { "#section-tabs" }
  let(:discussions_link) { "Discussions" }
  let(:discussion_container) { '[data-testid="discussion-topic-container"]' }
  let(:discussion_menu) { '[data-position-content="discussion-post-menu"]' }
  let(:discussion_reply_button) { '[data-testid="discussion-topic-reply"]' }
end

module DiscussionHelpers
  module SetupContext
    def setup_student_context
      let(:context_user) do
        course_with_student(course: @course, active_all: true, name: "student1")
        @student
      end
      let(:context_role) { student_role }
    end

    def setup_teacher_context
      let(:context_user) do
        course_with_teacher(course: @course, active_all: true, name: "teacher1")
        @teacher
      end
      let(:context_role) { teacher_role }
    end

    def setup_ta_context
      let(:context_user) do
        course_with_ta(course: @course, active_all: true, name: "ta1")
        @ta
      end
      let(:context_role) { ta_role }
    end

    def setup_observer_context
      let(:context_user) do
        course_with_student(course: @course, active_all: true, name: "student1")
        course_with_observer(course: @course, active_all: true, name: "observer1", associated_user_id: @student.id)
        @observer
      end
      let(:context_role) { observer_role }
    end

    def setup_designer_context
      let(:context_user) do
        course_with_designer(course: @course, active_all: true, name: "designer1")
        @designer
      end
      let(:context_role) { designer_role }
    end
  end

  class << self
    def create_discussion_topic(context, user, title, message, assignment = nil)
      context.discussion_topics.create!(
        user:,
        title:,
        message:,
        assignment:
      )
    end

    def disable_view_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "read_forum",
                                                 role: context_role,
                                                 enabled: false)
    end

    def disable_moderate_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "moderate_forum",
                                                 role: context_role,
                                                 enabled: false)
    end

    def disable_create_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "create_forum",
                                                 role: context_role,
                                                 enabled: false)
    end

    def disable_post_to_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "post_to_forum",
                                                 role: context_role,
                                                 enabled: false)
    end

    def enable_view_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "read_forum",
                                                 role: context_role,
                                                 enabled: true)
    end

    def enable_moderate_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "moderate_forum",
                                                 role: context_role,
                                                 enabled: true)
    end

    def enable_post_to_discussions(course, context_role)
      course.root_account.role_overrides.create!(permission: "post_to_forum",
                                                 role: context_role,
                                                 enabled: true)
    end
  end
end
