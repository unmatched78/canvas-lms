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

module Api::V1::Rubric
  include Api::V1::Json
  include Api::V1::RubricAssessment
  include Api::V1::RubricAssociation
  include Api::V1::Outcome

  API_ALLOWED_RUBRIC_OUTPUT_FIELDS = {
    only: %w[
      id
      title
      context_id
      context_type
      points_possible
      reusable
      public
      read_only
      free_form_criterion_comments
      hide_score_total
      data
      rating_order
    ]
  }.freeze

  def rubrics_json(rubrics, user, session, opts = {})
    rubrics.map { |r| rubric_json(r, user, session, opts) }
  end

  def rubric_json(rubric, user, session, opts = {})
    json_attributes = API_ALLOWED_RUBRIC_OUTPUT_FIELDS
    hash = api_json(rubric, user, session, json_attributes)
    hash["criteria"] = rubric.data if opts[:style] == "full"
    hash["assessments"] = rubric_assessments_json(opts[:assessments], user, session, opts) unless opts[:assessments].nil?
    hash["associations"] = rubric_associations_json(opts[:associations], user, session, opts) unless opts[:associations].nil?
    hash
  end

  def rubric_pagination_url
    if @context.is_a? Course
      api_v1_course_rubrics_url(@context)
    else
      api_v1_account_rubrics_url(@context)
    end
  end

  def rubric_used_locations_pagination_url(rubric)
    if @context.is_a? Course
      api_v1_rubrics_course_used_locations_path(
        course_id: @context.id, id: rubric.id, include_host: true
      )
    else
      api_v1_rubrics_account_used_locations_path(
        account_id: @context.id, id: rubric.id, include_host: true
      )
    end
  end

  def enhanced_rubrics_assignments_js_env(assignment)
    return unless assignment && Rubric.enhanced_rubrics_assignments_enabled?(@context)

    rubric_association = nil
    assigned_rubric = nil
    if assignment.active_rubric_association?
      rubric_association = assignment.rubric_association
      can_update_rubric = can_do(rubric_association.rubric, @current_user, :update)
      assigned_rubric = rubric_json(rubric_association.rubric, @current_user, session, style: "full")
      assigned_rubric[:unassessed] = Rubric.active.unassessed.where(id: rubric_association.rubric.id).exists?
      assigned_rubric[:can_update] = can_update_rubric
      assigned_rubric[:association_count] = RubricAssociation.active.where(rubric_id: rubric_association.rubric.id, association_type: "Assignment").count
      rubric_association = rubric_association_json(rubric_association, @current_user, session)
    end

    rubrics_hash = {
      ACCOUNT_LEVEL_MASTERY_SCALES: @context.root_account.feature_enabled?(:account_level_mastery_scales),
      ASSIGNMENT_ID: assignment.id,
      COURSE_ID: @context.id,
      ROOT_OUTCOME_GROUP: outcome_group_json(@context.root_outcome_group, @current_user, session),
      ai_rubrics_enabled: Rubric.ai_rubrics_enabled?(@context),
      assigned_rubric:,
      rubric_association:,
      rubric_self_assessment_ff_enabled: Rubric.rubric_self_assessment_enabled?(@context),
      rubric_self_assessment_enabled: @assignment.rubric_self_assessment_enabled?,
      can_update_rubric_self_assessment: @assignment.can_update_rubric_self_assessment?,
    }
    js_env(rubrics_hash)
  end
end
